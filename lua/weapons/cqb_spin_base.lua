AddCSLuaFile()

CQB_register_base('cqb_spin_base')

SWEP.Base				   	= 'cqb_base'

SWEP.Category			   	= 'S T O L E N  C O D E ™'
SWEP.PrintName			  	= 'cqb_spin_base'

SWEP.Spawnable			  	= false

SWEP.Author 				= 'JFAexe'

SWEP.SpinSnd  				= Sound('weapons/galil/galil_boltpull.wav')
SWEP.MaxSpin  				= 10
SWEP.SpinSpd  				= 10


--[[------------------------------------------------------------------------------------------------------
	Base
--------------------------------------------------------------------------------------------------------]]
function SWEP:SetupDataTables()
	self:AddNWVar('Float', 'Spin')
	self:AddNWVar('Float', 'Delay')

	self:AddDataTables()
end

function SWEP:Precache()
	util.PrecacheSound(self.Primary.SoundData.snd)
	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.WorldModel)

	util.PrecacheSound(self.SpinSnd)

	self:CustomPrecache()
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)

	local delay = CurTime() + self.Owner:GetViewModel():SequenceDuration()

	self:SetNextPrimaryFire(delay)
	self:SetNextSecondaryFire(delay)

	self:SetDelay(delay)
	
	self:OnDeploy()

	return true
end


--[[------------------------------------------------------------------------------------------------------
	Functionality
--------------------------------------------------------------------------------------------------------]]
function SWEP:CanPrimaryAttack()
	local data 	= self.Primary
	local delay = CurTime() + data.Delay

	if (self:Ammo1() <= 0 and self:Ammo1() < data.TakeAmmo) then
		self:EmitCustomSound(self.DryfireSnd, 70, 120)

		self:SetNextPrimaryFire(delay)
		self:SetNextSecondaryFire(delay)

		return
	end

	if self.Owner:KeyDown(IN_ATTACK) and self:GetSpin() < self.MaxSpin then

		local delay = CurTime() + data.Delay

		self:SetNextPrimaryFire(delay)
		self:SetNextSecondaryFire(delay)

		self:EmitCustomSound(self.SpinSnd, 45, 80)
	end

	return self:GetSpin() == self.MaxSpin
end

local _spin = 0

function SWEP:Think()
	self:WeaponThink()

	local data, owner = self.Primary, self:GetOwner()

	if not data.AmmoLimit then return end

	if owner:GetAmmoCount(self:GetPrimaryAmmoType()) > data.MaxAmmo then
		owner:SetAmmo(data.MaxAmmo, data.Ammo)
	end

	self.ExtraText = 'Spin: ' .. math.Round(_spin / self.MaxSpin * 100)  .. '%'

	local FT = FrameTime()

	self:SetSpin(_spin)

	if self:GetDelay() > CurTime() then
		_spin = math.Approach(_spin, 0, self.SpinSpd * 0.25 * FT)

		return
	end

	if owner:KeyDown(IN_ATTACK) then
		_spin = math.Approach(_spin, self.MaxSpin, self.SpinSpd * FT)
	else
		_spin = math.Approach(_spin, 0, self.SpinSpd * 0.25 * FT)
	end
end


--[[------------------------------------------------------------------------------------------------------
	HUD
--------------------------------------------------------------------------------------------------------]]
if CLIENT then
	function SWEP:CustomAmmoDisplay()
		self.AmmoDisplay = self.AmmoDisplay or {}

		self.AmmoDisplay.Draw = true

		self.AmmoDisplay.PrimaryClip = self:Ammo1()
		self.AmmoDisplay.PrimaryAmmo = math.Round(_spin / self.MaxSpin * 100)

		return self.AmmoDisplay
	end
end