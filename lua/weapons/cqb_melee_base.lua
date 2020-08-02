AddCSLuaFile()

-- Custom Quake melee base (now with backstabs)

--[[------------------------------------------------------------------------------------------------------
	Necessary info
--------------------------------------------------------------------------------------------------------]]
SWEP.Base					= 'cqb_base'

SWEP.Category				= 'S T O L E N  C O D E ™'
SWEP.PrintName				= 'cqb_melee_base'

SWEP.Author 				= 'JFAexe'

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false
SWEP.AdminOnly 				= false

SWEP.Slot 					= 0
SWEP.SlotPos 				= 0


--[[------------------------------------------------------------------------------------------------------
	Sounds
--------------------------------------------------------------------------------------------------------]]
SWEP.Primary.RandPitch		= 20
SWEP.Primary.SoundHitEnemy	= {
	snd = Sound('Weapon_Crowbar.Melee_Hit'),
	vol = 65,
	pit = 90
}
SWEP.Primary.SoundHitWorld	= {
	snd = Sound('Weapon_Crowbar.Melee_HitWorld'),
	vol = 65,
	pit = 90
}
SWEP.Primary.SoundMiss		= {
	snd = Sound('Weapon_Crowbar.Single'),
	vol = 65,
	pit = 90
}


--[[------------------------------------------------------------------------------------------------------
	Attack
--------------------------------------------------------------------------------------------------------]]
SWEP.Primary.Damage			= 20
SWEP.Primary.StabDamage		= 80
SWEP.Primary.DelayMiss		= 0.4
SWEP.Primary.DelayHit		= 0.3
SWEP.Primary.Force			= 10
SWEP.Primary.Distance		= 60
SWEP.Primary.DamageType		= DMG_CLUB

SWEP.AnimMiss				= 'midslash1'
SWEP.AnimHit				= 'stab'
SWEP.AnimStab				= 'stab_miss'

SWEP.ViewPunchMiss			= Angle(0, 0, 0)
SWEP.ViewPunchHit			= Angle(0, 0, 0)
SWEP.ViewPunchStab			= Angle(0, 0, 0)

SWEP.CanStab				= true

SWEP.AttackBounds			= {
	mins = Vector(-16, -16, -16),
	maxs = Vector(16, 16, 16)
}

--[[------------------------------------------------------------------------------------------------------
	View Model
--------------------------------------------------------------------------------------------------------]]
SWEP.ViewModelFOV			= 80
SWEP.ViewModelFlip			= false
SWEP.UseHands				= false
SWEP.LightedViewmodel		= false
SWEP.ShowViewModel			= true
SWEP.ViewModel				= 'models/weapons/c_crowbar.mdl'
SWEP.VMPos					= Vector(0, 0, 0)
SWEP.VMAng					= Angle(0, 0, 0)
SWEP.AltVMPos				= Vector(0, 0, 0)
SWEP.AltVMAng				= Angle(0, 0, 0)


--[[------------------------------------------------------------------------------------------------------
	World Model
--------------------------------------------------------------------------------------------------------]]
SWEP.WorldModel				= 'models/weapons/w_crowbar.mdl'
SWEP.HoldType				= 'knife'
SWEP.WorldModelData			= {
	Pos	= {
		Up		= 0,
		Right	= 0,
		Forward	= 0,
	},
	Ang	= {
		Up		= 0,
		Right	= 0,
		Forward	= 180
	},
	Scale	= 1
}


--[[------------------------------------------------------------------------------------------------------
	SCK
--------------------------------------------------------------------------------------------------------]]
SWEP.ViewModelBoneMods		= {}
SWEP.VElements				= {}
SWEP.WElements				= {}


--[[------------------------------------------------------------------------------------------------------
	Base specific
--------------------------------------------------------------------------------------------------------]]
SWEP.ExtraText				= ''

SWEP.SpeedMultiply			= 1


--[[------------------------------------------------------------------------------------------------------
	Disable some things
--------------------------------------------------------------------------------------------------------]]
SWEP.DrawAmmo				= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Ammo			= 'none'

SWEP.LuaShells				= false


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


--[[------------------------------------------------------------------------------------------------------
	Functionality
--------------------------------------------------------------------------------------------------------]]
function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	if IsFirstTimePredicted() then
		self:MeleeAttack()
	end
end

function SWEP:MeleeAttack()
	local owner	= self:GetOwner()
	local vm	= owner:GetViewModel()
	local data	= self.Primary
	local hite	= data.SoundHitEnemy
	local hitw	= data.SoundHitWorld
	local miss	= data.SoundMiss
	local delm	= CurTime() + data.DelayMiss
	local delh	= CurTime() + data.DelayHit

	local Rand	= math.Rand

	owner:ViewPunchReset()

	self:SendWeaponAnim(ACT_VM_IDLE)

	if SERVER then owner:LagCompensation(true) end

	local dir = Vector(1, 1, 1)
	local angles = owner:EyeAngles()
	local forward = angles:Forward()

	local trace = {}
	trace.filter	= owner
	trace.start		= owner:GetShootPos()
	trace.endpos	= trace.start + forward * data.Distance
	trace.mins		= self.AttackBounds.mins:Rotate(angles)
	trace.maxs		= self.AttackBounds.maxs:Rotate(angles)
	trace.mask		= MASK_SHOT_HULL

	local tr = util.TraceLine(trace)

	local ent = tr.Entity

	if not IsValid(ent) then
		local tr = util.TraceHull(trace)
	elseif ent:IsValid() and not self:TargetIsABeing(ent) then
		local phys = ent:GetPhysicsObject()

		phys:ApplyForceOffset(forward * data.Force * 1000, tr.HitPos)
	end

	if tr.Hit then
		local stab = self:CheckBackstab(ent)
		local power = stab and 1000 or 100

		if SERVER then
			local Dmg = DamageInfo()
			Dmg:SetAttacker(owner)
			Dmg:SetInflictor(self)
			Dmg:SetDamage(stab and data.StabDamage or data.Damage)
			Dmg:SetDamageType(data.DamageType)
			Dmg:SetDamagePosition(tr.HitPos)
			Dmg:SetDamageForce(dir * data.Force * forward * power)

			ent:TakeDamageInfo(Dmg)
		end

		if SERVER or IsFirstTimePredicted() then
			local stbl = self:TargetIsABeing(ent) and hite or hitw

			self:EmitCustomSound(stbl.snd, stbl.vol, stbl.pit + Rand(-data.RandPitch, data.RandPitch))
		end

		self:DoImpactEffect(tr)

		self:AddDelay(delh)

		vm:SendViewModelMatchingSequence(vm:LookupSequence(stab and self.AnimStab or self.AnimHit))

		owner:ViewPunch(stab and self.ViewPunchStab or self.ViewPunchHit)
	else
		self:EmitCustomSound(miss.snd, miss.vol, miss.pit + Rand(-data.RandPitch, data.RandPitch))

		self:AddDelay(delm)

		vm:SendViewModelMatchingSequence(vm:LookupSequence(self.AnimMiss))

		owner:ViewPunch(self.ViewPunchMiss)
	end

	if SERVER then owner:LagCompensation(false) end

	owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:CheckBackstab(ent)
	if not self.CanStab or not self:TargetIsABeing(ent) then return false end

	local ownang = self:GetOwner():EyeAngles()
	ownang.p = 0
	ownang = ownang:Forward()

	local entang = ent:EyeAngles()
	entang.p = 0
	entang = entang:Forward()
	
	return entang:DotProduct(ownang) >= 0.7
end


--[[------------------------------------------------------------------------------------------------------
	Effects
--------------------------------------------------------------------------------------------------------]]
function SWEP:DoImpactEffect(tr, dmgtype)
	if tr.HitSky then return end

	if self:TargetIsABeing(tr.Entity) then
		local ef = EffectData()
		ef:SetOrigin(tr.HitPos)

		util.Effect('BloodImpact', ef, true, true)
	end

	return true
end