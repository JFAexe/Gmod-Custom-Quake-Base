-- Clean code, bruh (still strying to fix github's tab breaking)

AddCSLuaFile()

CQB_register_base('cqb_base')

local render, table, pairs = render, table, pairs
local Clamp, Rand = math.Clamp, math.Rand

SWEP.Base					= 'weapon_base'

SWEP.Category				= 'S T O L E N  C O D E ™'
SWEP.PrintName				= 'cqb_base'

SWEP.Author					= 'JFAexe'

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false
SWEP.AdminOnly				= false

SWEP.Slot					= 0
SWEP.SlotPos				= 0

SWEP.DrawCrosshair			= false
SWEP.DrawAmmo				= true

SWEP.Primary.SoundData		= {
	snd = Sound('weapons/fiveseven/fiveseven-1.wav'),
	vol = 75,
	pit = 90
}
SWEP.Primary.DryfireData	= {
	snd = Sound('weapons/mac10/mac10_boltpull.wav'),
	vol = 70,
	pit = 150
}

SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.RPM			= 800
SWEP.Primary.HorizSpread	= 1
SWEP.Primary.VertSpread		= 0
SWEP.Primary.Recoil			= 0.7
SWEP.Primary.Force			= 0.5
SWEP.Primary.DamageType		= DMG_BULLET

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.TakeAmmo		= 1
SWEP.Primary.AmmoLimit		= false
SWEP.Primary.MaxAmmo		= 100
SWEP.Primary.Ammo			= 'SMG1'

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			= 'none'

SWEP.SwayScale				= 0
SWEP.BobScale				= 0

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.UseHands				= false
SWEP.ViewModel				= 'models/weapons/cstrike/c_rif_ak47.mdl'
SWEP.VMPos					= Vector(0, 0, 0)
SWEP.VMAng					= Angle(0, 0, 0)
SWEP.AltVMPos				= Vector(0, 0, 0)
SWEP.AltVMAng				= Angle(0, 0, 0)

SWEP.HoldType				= 'ar2'
SWEP.WorldModel				= 'models/weapons/w_rif_ak47.mdl'
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

SWEP.ViewModelBoneMods		= {}
SWEP.VElements				= {}
SWEP.WElements				= {}

SWEP.XMuzzleflash			= false
SWEP.DisableMuzzleflash		= false
SWEP.DisableShells			= false

SWEP.XMuzzleflashSize		= 1
SWEP.TracerEffect			= 'tracer'

SWEP.Heavy					= false
SWEP.SpeedMultiply			= 1

SWEP.ExtraText				= ''


--[[------------------------------------------------------------------------------------------------------
	Base
--------------------------------------------------------------------------------------------------------]]
function SWEP:AddDelay(delay)
	self:SetNextPrimaryFire(delay)
	self:SetNextSecondaryFire(delay)
end

function SWEP:EmitCustomSound(sound, volume, pitch)
	self:EmitSound(sound, volume, pitch, 1, CHAN_WEAPON)
end

SWEP.DataTableReserve = {
	['String']	= 0,
	['Bool']	= 0,
	['Float']	= 0,
	['Int']		= 0,
	['Vector']	= 0,
	['Angle']	= 0,
	['Entity']	= 0
}

function SWEP:AddNWVar(type, variable)
	if self.DataTableReserve[type] == nil then return end

	self:NetworkVar(type, self.DataTableReserve[type], variable)

	self.DataTableReserve[type] = self.DataTableReserve[type] + 1
end

function SWEP:SetupDataTables()
	self:AddDataTables()
end

function SWEP:AddDataTables()
	return
end

function SWEP:Precache()
	local data	= self.Primary

	util.PrecacheSound(data.SoundData.snd)
	util.PrecacheSound(data.DryfireData.snd)

	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.WorldModel)

	self:CustomPrecache()
end

function SWEP:CustomPrecache()
	return
end

function SWEP:Initialize()
	self:Precache()

	self:SetHoldType(self.HoldType)

	self.Primary.Delay = 1 / (self.Primary.RPM / 60)

	if CLIENT then self:InitSCK() end

	self:OnInitialize()
end

function SWEP:OnInitialize()
	return
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)

	local delay = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()

	self:AddDelay(delay)

	self:OnDeploy()

	return true
end

function SWEP:OnDeploy()
	return
end

function SWEP:Holster()
	self:HolsterSCK()

	self:OnHolster()

	return true
end

function SWEP:OnHolster()
	return
end

function SWEP:OnRemove()
	self:Holster()
end


--[[------------------------------------------------------------------------------------------------------
	Functionality
--------------------------------------------------------------------------------------------------------]]
function SWEP:CanPrimaryAttack()
	return self:AmmoCheck()
end

function SWEP:AmmoCheck()
	local data	= self.Primary
	local dry	= data.DryfireData
	local delay	= CurTime() + data.Delay

	if self:Ammo1() <= 0 and self:Ammo1() < data.TakeAmmo then
		self:EmitCustomSound(dry.snd, dry.vol, dry.pit)

		self:AddDelay(delay)

		return false
	end

	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:Attack()

	return
end

function SWEP:Attack()
	local data	= self.Primary
	local sound	= data.SoundData
	local owner	= self:GetOwner()
	local delay	= CurTime() + data.Delay

	if IsFirstTimePredicted() then
		self:EmitCustomSound(sound.snd, sound.vol, sound.pit)

		for i = 1, data.NumShots do self:ShootBullet() end
	end

	self:TakePrimaryAmmo(data.TakeAmmo)
	self:AddDelay(delay)

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	owner:SetAnimation(PLAYER_ATTACK1)

	owner:ViewPunchReset()
	owner:ViewPunch(Angle(Rand(-data.Recoil, -data.Recoil * 0.75), 0, 0))
end

function SWEP:ShootBullet()
	local owner = self:GetOwner()
	local data  = self.Primary

	local Vec = owner:GetAimVector():Angle()
	Vec:RotateAroundAxis(Vec:Right(),	Rand(-data.VertSpread, data.VertSpread))
	Vec:RotateAroundAxis(Vec:Up(),		Rand(-data.HorizSpread, data.HorizSpread))
	Vec:RotateAroundAxis(Vec:Forward(),	0)

	local bullet		= {}
	bullet.Damage		= data.Damage
	bullet.Force		= data.Force
	bullet.Tracer		= 1
	bullet.Num			= 1
	bullet.Src			= owner:GetShootPos()
	bullet.Dir			= owner:GetAimVector() + Vec:Forward()
	bullet.Spread		= Vector(0, 0, 0)
	bullet.TracerName	= self.TracerEffect
	bullet.Callback		= function(attacker, tr, damage)
		damage:SetDamageType(data.DamageType or DMG_BULLET) -- bruh
	end

	owner:FireBullets(bullet)

	if self.Heavy then owner:SetVelocity(owner:GetForward() * (data.Force * -100)) end
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Reload()
	return
end

function SWEP:Think()
	self:WeaponThink()

	self:LimitAmmo()
end

function SWEP:WeaponThink()
	return
end

function SWEP:LimitAmmo()
	local data, owner = self.Primary, self:GetOwner()

	if not data.AmmoLimit then return end

	if owner:GetAmmoCount(self:GetPrimaryAmmoType()) > data.MaxAmmo then
		owner:SetAmmo(data.MaxAmmo, data.Ammo)
	end
end


--[[------------------------------------------------------------------------------------------------------
	Effects
--------------------------------------------------------------------------------------------------------]]
function SWEP:FireAnimationEvent(pos, ang, event, name)
	local Shells = {
		[20]	= true,
		[21]	= true,
		[6001]	= true
	}

	local Muzzles = {
		[5001]	= true,
		[5003]	= true,
		[5011]	= true,
		[5021]	= true,
		[5031]	= true 
	}

	if Shells[event] then return self.DisableShells end

	if Muzzles[event] then
		if self.XMuzzleflash then
			local ef = EffectData()
			ef:SetEntity(self:GetOwner():GetViewModel())
			ef:SetAttachment(math.floor((event - 4991) / 10))
			ef:SetScale(self.XMuzzleflashSize)

			util.Effect('CS_MuzzleFlash_X', ef)
		end

		return self.DisableMuzzleflash
	end
end


--[[------------------------------------------------------------------------------------------------------
	VM
--------------------------------------------------------------------------------------------------------]]
local VMAnimation, VMBob		= 0, 0
local SwayMod, LeanMod, Lean	= 3, 1.4, 1
local SwayAng, SwayAngFin		= Angle(), Angle()

function SWEP:SwayVMPos(pos, ang, FT)
	local owner = self:GetOwner()

	local angdelta = owner:EyeAngles() - SwayAng

	if angdelta.y >= 180 then angdelta.y = angdelta.y - 360 elseif angdelta.y <= -180 then  angdelta.y = angdelta.y + 360 end

	angdelta.p = Clamp(angdelta.p, -90, 90)
	angdelta.y = Clamp(angdelta.y, -90, 90)
	angdelta.r = Clamp(angdelta.r, -90, 90)

	if owner:KeyDown(IN_MOVERIGHT) and not owner:KeyDown(IN_MOVELEFT) then
		Lean = Lerp(Clamp(FT * 2, 0, 1), Lean, LeanMod * (self.ViewModelFlip and -2 or 2))
	elseif owner:KeyDown(IN_MOVELEFT) and not owner:KeyDown(IN_MOVERIGHT) then
		Lean = Lerp(Clamp(FT * 2, 0, 1), Lean, LeanMod * (self.ViewModelFlip and 2 or -2))
	else
		Lean = Lerp(Clamp(FT * 4, 0, 1), Lean, 0)
	end

	SwayAngFin	= LerpAngle(Clamp(FT * 4, 0, 1), SwayAngFin, angdelta * (self.ViewModelFlip and -1 or 1))
	SwayAng		= owner:EyeAngles()

	ang:RotateAroundAxis(ang:Right(),	-SwayAngFin.p	* SwayMod)
	ang:RotateAroundAxis(ang:Up(),		SwayAngFin.y	* SwayMod)
	ang:RotateAroundAxis(ang:Forward(),	SwayAngFin.y	* SwayMod)

	pos = pos + ang:Right() * SwayAngFin.y * SwayMod / 2 + ang:Up() * SwayAngFin.p * SwayMod / 2
	ang = ang + Angle(0, 0, Lean * 4)

	return pos, ang
end

function SWEP:DoVMPos(pos, ang)
	local bool	= GetConVar('cqb_altpos'):GetBool()
	local tblp	= bool and self.AltVMPos or self.VMPos
	local tbla	= bool and self.AltVMAng or self.VMAng

	ang:RotateAroundAxis(ang:Right(),	tbla.p)
	ang:RotateAroundAxis(ang:Up(),		tbla.y)
	ang:RotateAroundAxis(ang:Forward(),	tbla.r)

	pos = pos + ang:Forward()	* tblp.y
	pos = pos + ang:Right()		* tblp.x
	pos = pos + ang:Up()		* tblp.z

	return pos, ang
end

function SWEP:GetViewModelPosition(pos, ang)
	local owner = self:GetOwner()

	if not owner:IsValid() then return pos, ang end

	local FT		= RealFrameTime()
	local CalcVel	= Clamp(owner:GetVelocity():Length() / 600, 0 , 3) / self.SpeedMultiply

	if owner:OnGround() then
		VMAnimation = Lerp(FT * 4, VMAnimation, math.sin(CurTime() * 8) * CalcVel)
	else
		VMAnimation = Lerp(0.1, VMAnimation, 0)
	end

	pos = pos + ang:Forward() * VMAnimation * 5

	pos, ang = self:DoVMPos(pos, ang)
	pos, ang = self:SwayVMPos(pos, ang, FT)

	return pos, ang
end

function SWEP:PreDrawViewModel(vm)
	render.PushFilterMag(TEXFILTER.POINT)
	render.PushFilterMin(TEXFILTER.POINT)

	self:OnPreDrawViewModel(vm)
end

function SWEP:OnPreDrawViewModel(vm)
	return
end

function SWEP:PostDrawViewModel(vm)
	render.PopFilterMag()
	render.PopFilterMin()

	self:OnPostDrawViewModel(vm)
end

function SWEP:OnPostDrawViewModel(vm)
	return
end


--[[------------------------------------------------------------------------------------------------------
	View
--------------------------------------------------------------------------------------------------------]]
function SWEP:CalcView(ply, origin, angles, fov)
	if IsFirstTimePredicted() or not GetConVar('cqb_viewbob'):GetBool() then return end

	local FT, owner = FrameTime(), self:GetOwner()

	if owner:KeyDown(IN_MOVERIGHT) then
		VMBob = Lerp(FT * 6, VMBob, owner:GetVelocity():Length() / 200)
	elseif owner:KeyDown(IN_MOVELEFT) then
		VMBob = Lerp(FT * 6, VMBob, -owner:GetVelocity():Length() / 200)
	else
		VMBob = Lerp(FT * 6, VMBob, 0)
	end

	angles = angles + Angle(VMAnimation * -2, 0, VMBob)

	return origin, angles, fov
end


--[[------------------------------------------------------------------------------------------------------
	HUD
--------------------------------------------------------------------------------------------------------]]
if CLIENT then
	function SWEP:DrawCrosshair()
		if not GetConVar('cqb_hud_crosshair'):GetBool() then return end

		local styles   = {
			l   = { '-', '~', ':', '[', '(', '{', '<', '>', '|', '/', '\\' },
			r   = { '-', '~', ':', ']', ')', '}', '>', '<', '|', '\\', '/' },
		}

		local cross = ' '

		for i = 0, math.Round(self.Primary.HorizSpread * 2) do cross = cross .. ' ' end

		local _style = GetConVar('cqb_hud_crosshairstyle'):GetInt()
		CQB_ShadowText(styles.l[_style] .. cross .. styles.r[_style], 'CQBMicro', CQB_swc, CQB_shc - 2)
	end

	function SWEP:DrawHUD()
		local owner = self:GetOwner()

		self:DrawCrosshair()

		if not GetConVar('cqb_hud_enabled'):GetBool() then return end

		local _x	= GetConVar('cqb_hud_x'):GetFloat()
		local horz	= CQB_swc * _x
		local fcl	= CQB_swc - horz
		local tcl	= CQB_swc + horz

		local _y	= GetConVar('cqb_hud_y'):GetFloat()
		local cus	= CQB_sh - CQB_shc * (_y + 0.21)
		local top	= CQB_sh - CQB_shc * (_y + 0.14)
		local mid	= CQB_sh - CQB_shc * (_y + 0.07)
		local bot	= CQB_sh - CQB_shc * (_y)

		CQB_ShadowText(owner:Nick(), 'CQBSmall', fcl, top)
		CQB_ShadowText(CQB_format(owner:Health()), 'CQBLarge', fcl, mid)

		CQB_ShadowText('Armor', 'CQBSmall', tcl, top)
		CQB_ShadowText(CQB_format(owner:Armor()), 'CQBLarge', tcl, mid)

		CQB_ShadowText(self.PrintName, 'CQBMedium', CQB_swc, top)
		CQB_ShadowText(self:GetOwner():GetAmmoCount(self.Primary.Ammo), 'CQBLarge', CQB_swc, mid)
		CQB_ShadowText(self.Primary.Ammo, 'CQBSmall', CQB_swc, bot)

		CQB_ShadowText(self.ExtraText or '', 'CQBSmall', CQB_swc, cus)
	end

	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		CQB_ShadowText(self.PrintName, 'CQBSmall', x + wide / 2, y + tall / 2 - 10)
	end

	function SWEP:CustomAmmoDisplay()
		self.AmmoDisplay = self.AmmoDisplay or {}

		self.AmmoDisplay.Draw = true

		self.AmmoDisplay.PrimaryClip = self:Ammo1()

		return self.AmmoDisplay
	end
end


--[[------------------------------------------------------------------------------------------------------
	SCK
--------------------------------------------------------------------------------------------------------]]
function SWEP:CustomDrawWorldModel()
	local owner = self:GetOwner()
	local data  = self.WorldModelData

	if IsValid(owner) then
		local boneIndex = owner:LookupBone('ValveBiped.Bip01_R_Hand')

		if boneIndex then
			local pos, ang = owner:GetBonePosition(boneIndex)
			pos = pos + ang:Forward() * data.Pos.Forward
			pos = pos + ang:Right() * data.Pos.Right
			pos = pos + ang:Up() * data.Pos.Up
			ang:RotateAroundAxis(ang:Up(), data.Ang.Up)
			ang:RotateAroundAxis(ang:Right(), data.Ang.Right)
			ang:RotateAroundAxis(ang:Forward(), data.Ang.Forward)
			self:SetRenderOrigin(pos)
			self:SetRenderAngles(ang)
			self:SetModelScale(data.Scale)

			if (self.ShowWorldModel == nil or self.ShowWorldModel) then
				self:DrawModel()
			end
		end
	else
		self:SetRenderOrigin(nil)
		self:SetRenderAngles(nil)

		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
	end
end

function SWEP:InitSCK()
	local owner = self:GetOwner()

	if CLIENT then
		self.VElements = table.FullCopy(self.VElements)
		self.WElements = table.FullCopy(self.WElements)
		self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)
		self:CreateModels(self.VElements)
		self:CreateModels(self.WElements)

		if IsValid(owner) then
			local vm = owner:GetViewModel()

			if IsValid(vm) then
				self:ResetBonePositions(vm)

				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255, 255, 255, 255))
				else
					vm:SetColor(Color(255, 255, 255, 1))
					vm:SetMaterial('Debug/hsv')
				end
			end
		end
	end
end

function SWEP:HolsterSCK()
	local owner = self:GetOwner()

	if CLIENT and IsValid(owner) then
		local vm = owner:GetViewModel()

		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end

	return true
end

if CLIENT then
	SWEP.vRenderOrder = nil

	function SWEP:ViewModelDrawn()
		local owner = self:GetOwner()

		local vm = owner:GetViewModel()
		if not IsValid(vm) then return end
		if (not self.VElements) then return end
		self:UpdateBonePositions(vm)

		if (not self.vRenderOrder) then
			self.vRenderOrder = {}

			for k, v in pairs(self.VElements) do
				if (v.type == 'Model') then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == 'Sprite' or v.type == 'Quad') then
					table.insert(self.vRenderOrder, k)
				end
			end
		end

		for k, name in ipairs(self.vRenderOrder) do
			local v = self.VElements[name]

			if (not v) then
				self.vRenderOrder = nil
				break
			end

			if (v.hide) then continue end
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			if (not v.bone) then continue end
			local pos, ang = self:GetBoneOrientation(self.VElements, v, vm)
			if (not pos) then continue end

			if (v.type == 'Model' and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix('RenderMultiply', matrix)

				if (v.material == '') then
					model:SetMaterial('')
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial(v.material)
				end

				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end

				if (v.bodygroup) then
					for k, v in pairs(v.bodygroup) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end

				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end

				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)

				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
			elseif (v.type == 'Sprite' and sprite) then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif (v.type == 'Quad' and v.draw_func) then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
				cam.End3D2D()
			end
		end
	end

	SWEP.wRenderOrder = nil

	function SWEP:DrawWorldModel()
		self:CustomDrawWorldModel()

		if (not self.WElements) then return end

		if (not self.wRenderOrder) then
			self.wRenderOrder = {}

			for k, v in pairs(self.WElements) do
				if (v.type == 'Model') then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == 'Sprite' or v.type == 'Quad') then
					table.insert(self.wRenderOrder, k)
				end
			end
		end

		local owner = self:GetOwner()

		bone_ent = IsValid(owner) and owner or self

		for k, name in pairs(self.wRenderOrder) do
			local v = self.WElements[name]

			if (not v) then
				self.wRenderOrder = nil
				break
			end

			if (v.hide) then continue end
			local pos, ang

			if (v.bone) then
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent)
			else
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent, 'ValveBiped.Bip01_R_Hand')
			end

			if (not pos) then continue end
			local model = v.modelEnt
			local sprite = v.spriteMaterial

			if (v.type == 'Model' and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix('RenderMultiply', matrix)

				if (v.material == '') then
					model:SetMaterial('')
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial(v.material)
				end

				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end

				if (v.bodygroup) then
					for k, v in pairs(v.bodygroup) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end

				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end

				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)

				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
			elseif (v.type == 'Sprite' and sprite) then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif (v.type == 'Quad' and v.draw_func) then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
				cam.End3D2D()
			end
		end
	end

	function SWEP:GetBoneOrientation(basetab, tab, ent, bone_override)
		local bone, pos, ang

		if (tab.rel and tab.rel ~= '') then
			local v = basetab[tab.rel]
			if (not v) then return end
			pos, ang = self:GetBoneOrientation(basetab, v, ent)
			if (not pos) then return end
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
		else
			bone = ent:LookupBone(bone_override or tab.bone)
			if (not bone) then return end
			pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
			local m = ent:GetBoneMatrix(bone)

			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end

			local owner = self:GetOwner()

			if (IsValid(owner) and owner:IsPlayer() and ent == owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r
			end
		end

		return pos, ang
	end

	function SWEP:CreateModels(tab)
		if (not tab) then return end

		for k, v in pairs(tab) do
			if (v.type == 'Model' and v.model and v.model ~= '' and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) and string.find(v.model, '.mdl') and file.Exists(v.model, 'GAME')) then
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)

				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
			elseif (v.type == 'Sprite' and v.sprite and v.sprite ~= '' and (not v.spriteMaterial or v.createdSprite ~= v.sprite) and file.Exists('materials/' .. v.sprite .. '.vmt', 'GAME')) then
				local name = v.sprite .. '-'

				local params = {
					['$basetexture'] = v.sprite
				}

				local tocheck = {'nocull', 'additive', 'vertexalpha', 'vertexcolor', 'ignorez'}

				for i, j in pairs(tocheck) do
					if (v[j]) then
						params['$' .. j] = 1
						name = name .. '1'
					else
						name = name .. '0'
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name, 'UnlitGeneric', params)
			end
		end
	end

	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		if self.ViewModelBoneMods then
			if (not vm:GetBoneCount()) then return end
			local loopthrough = self.ViewModelBoneMods

			if (not hasGarryFixedBoneScalingYet) then
				allbones = {}

				for i = 0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)

					if (self.ViewModelBoneMods[bonename]) then
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = {
							scale = Vector(1, 1, 1),
							pos = Vector(0, 0, 0),
							angle = Angle(0, 0, 0)
						}
					end
				end

				loopthrough = allbones
			end

			for k, v in pairs(loopthrough) do
				local bone = vm:LookupBone(k)
				if (not bone) then continue end
				local s = Vector(v.scale.x, v.scale.y, v.scale.z)
				local p = Vector(v.pos.x, v.pos.y, v.pos.z)
				local ms = Vector(1, 1, 1)

				if (not hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)

					while (cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end

				s = s * ms

				if vm:GetManipulateBoneScale(bone) ~= s then
					vm:ManipulateBoneScale(bone, s)
				end

				if vm:GetManipulateBoneAngles(bone) ~= v.angle then
					vm:ManipulateBoneAngles(bone, v.angle)
				end

				if vm:GetManipulateBonePosition(bone) ~= p then
					vm:ManipulateBonePosition(bone, p)
				end
			end
		else
			self:ResetBonePositions(vm)
		end
	end

	function SWEP:ResetBonePositions(vm)
		if (not vm:GetBoneCount()) then return end

		for i = 0, vm:GetBoneCount() do
			vm:ManipulateBoneScale(i, Vector(1, 1, 1))
			vm:ManipulateBoneAngles(i, Angle(0, 0, 0))
			vm:ManipulateBonePosition(i, Vector(0, 0, 0))
		end
	end

	function table.FullCopy(tab)
		if (not tab) then return nil end
		local res = {}

		for k, v in pairs(tab) do
			if (type(v) == 'table') then
				res[k] = table.FullCopy(v)
			elseif (type(v) == 'Vector') then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == 'Angle') then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end

		return res
	end
end


-- Юра лох https://steamcommunity.com/sharedfiles/filedetails/?id=2164961319 (C) PD 22nd july 2020 21:47 gtm+3