AddCSLuaFile()

CQB_register_base('cqb_melee_base')

SWEP.Base					= 'cqb_base'

SWEP.Category				= 'S T O L E N  C O D E ™'
SWEP.PrintName				= 'cqb_melee_base'

SWEP.Author 				= 'JFAexe'

SWEP.Spawnable				= false

SWEP.DrawAmmo				= false

SWEP.Primary.SoundHitEnemy		= {
	snd = Sound('Weapon_Crowbar.Melee_Hit'),
	vol = 65,
	pit = 90
}
SWEP.Primary.SoundHitWorld		= {
	snd = Sound('Weapon_Crowbar.Melee_HitWorld'),
	vol = 65,
	pit = 90
}
SWEP.Primary.SoundMiss		= {
	snd = Sound('Weapon_Crowbar.Single'),
	vol = 65,
	pit = 90
}

SWEP.Primary.DelayMiss		= 0.4
SWEP.Primary.DelayHit		= 0.3
SWEP.Primary.Force			= 10
SWEP.Primary.Distance		= 60
SWEP.Primary.DamageType		= DMG_CLUB

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Ammo			= 'none'

SWEP.AnimHit				= ACT_VM_HITCENTER
SWEP.AnimMiss				= ACT_VM_MISSCENTER

SWEP.ViewModel				= 'models/weapons/c_crowbar.mdl'

SWEP.WorldModel				= 'models/weapons/w_crowbar.mdl'
SWEP.HoldType				= 'knife'

SWEP.SpeedMultiply			= 1.2


--[[------------------------------------------------------------------------------------------------------
	Base
--------------------------------------------------------------------------------------------------------]]
function SWEP:Precache()
	local data	= self.Primary

	util.PrecacheSound(data.SoundHitEnemy.snd)
	util.PrecacheSound(data.SoundHitWorld.snd)
	util.PrecacheSound(data.SoundMiss.snd)

	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.WorldModel)

	self:CustomPrecache()
end

function SWEP:Initialize()
	self:Precache()

	self:SetHoldType(self.HoldType)

	if CLIENT then self:InitSCK() end

	self:OnInitialize()
end

function SWEP:TargetIsABeing(tr)
	local ent = tr.Entity

	return ent:IsNPC() or ent:IsPlayer() or type(ent) == 'NextBot'
end


--[[------------------------------------------------------------------------------------------------------
	Functionality
--------------------------------------------------------------------------------------------------------]]
function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:MeleeAttack()
end

function SWEP:MeleeAttack()
	local owner	= self:GetOwner()
	local data	= self.Primary
	local hite	= data.SoundHitEnemy
	local hitw	= data.SoundHitWorld
	local miss	= data.SoundMiss
	local delm	= CurTime() + data.DelayMiss
	local delh	= CurTime() + data.DelayHit

	if SERVER then owner:LagCompensation(true) end

	local tr = util.TraceLine({
		filter	= owner,
		start	= owner:GetShootPos(),
		endpos	= owner:GetShootPos() + (owner:GetAimVector() * data.Distance),
		mins	= Vector(-16, -16, -16),
		maxs	= Vector(16, 16, 16),
	})

	local ent = tr.Entity

	if not IsValid(ent) then
		local tr = util.TraceHull({
			filter	= owner,
			start	= owner:GetShootPos(),
			endpos	= owner:GetShootPos() + (owner:GetAimVector() * data.Distance),
			mins	= Vector(-16, -16, -16),
			maxs	= Vector(16, 16, 16),
			mask	= MASK_SHOT_HULL
		})
	elseif ent:IsValid() and not self:TargetIsABeing(tr) then
		local phys = ent:GetPhysicsObjectNum(tr.PhysicsBone)

		phys:ApplyForceOffset(tr.Normal * data.Force * 100, tr.HitPos)
	end

	if tr.Hit then
		if SERVER then
			local Dmg = DamageInfo()
			Dmg:SetAttacker(owner)
			Dmg:SetInflictor(self)
			Dmg:SetDamage(data.Damage)
			Dmg:SetDamageType(data.DamageType)
			Dmg:SetDamageForce(owner:GetAimVector() * data.Force * 100)

			ent:TakeDamageInfo(Dmg)
		end

		if SERVER or IsFirstTimePredicted() then
			if self:TargetIsABeing(tr) then
				self:EmitCustomSound(hite.snd, hite.vol, hite.pit)
			else
				self:EmitCustomSound(hitw.snd, hitw.vol, hitw.pit)
			end
		end

		self:DoImpactEffect(tr)

		self:AddDelay(delh)

		self:SendWeaponAnim(self.AnimHit)
	else
		self:EmitCustomSound(miss.snd, miss.vol, miss.pit)

		self:AddDelay(delm)

		self:SendWeaponAnim(self.AnimMiss)
	end

	if SERVER then owner:LagCompensation(false) end

	owner:SetAnimation(PLAYER_ATTACK1)
end


--[[------------------------------------------------------------------------------------------------------
	Effects
--------------------------------------------------------------------------------------------------------]]
function SWEP:DoImpactEffect(tr, dmgtype)
	if tr.HitSky then return end

	if self:TargetIsABeing(tr) then
		local ef = EffectData()
		ef:SetOrigin(tr.HitPos)

		util.Effect('BloodImpact', ef, true, true)
	end

	return true
end


--[[------------------------------------------------------------------------------------------------------
	HUD
--------------------------------------------------------------------------------------------------------]]
if CLIENT then
	function SWEP:DrawHUD()
		local owner = self:GetOwner()

		self:DrawCrosshair()

		if not GetConVar('cqb_hud_enabled'):GetBool() then return end

		local _x	= GetConVar('cqb_hud_x'):GetFloat()
		local horz	= CQB_swc * _x
		local fcl	= CQB_swc - horz
		local tcl	= CQB_swc + horz

		local _y	= GetConVar('cqb_hud_y'):GetFloat()
		local cus	= CQB_sh - CQB_shc * (_y + 0.24)
		local top	= CQB_sh - CQB_shc * (_y + 0.17)
		local mid	= CQB_sh - CQB_shc * (_y + 0.08)
		local bot	= CQB_sh - CQB_shc * (_y)

		CQB_ShadowText(CQB_TextLimit(horz * 0.6, owner:Nick(), 'CQBSmall'), 'CQBSmall', fcl, top)
		CQB_ShadowText(CQB_format(owner:Health()), 'CQBLarge', fcl, mid)

		CQB_ShadowText('Armor', 'CQBSmall', tcl, top)
		CQB_ShadowText(CQB_format(owner:Armor()), 'CQBLarge', tcl, mid)

		CQB_ShadowText(CQB_TextLimit(horz * 1.4, self.PrintName, 'CQBMedium'), 'CQBMedium', CQB_swc, top)

		CQB_ShadowText(self.ExtraText or '', 'CQBSmall', CQB_swc, cus)
	end
end