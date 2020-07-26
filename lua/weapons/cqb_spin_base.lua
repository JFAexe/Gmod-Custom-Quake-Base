AddCSLuaFile()

CQB_register_base('cqb_spin_base')

SWEP.Base					= 'cqb_base'

SWEP.Category				= 'S T O L E N  C O D E ™'
SWEP.PrintName				= 'cqb_spin_base'

SWEP.Author					= 'JFAexe'

SWEP.Spawnable				= false

SWEP.Primary.SpinData		= {
	snd = Sound('weapons/galil/galil_boltpull.wav'),
	vol = 45,
	pit = 80
}

SWEP.Primary.MaxSpin		= 10
SWEP.Primary.SpinSpd		= 10


--[[------------------------------------------------------------------------------------------------------
	Base
--------------------------------------------------------------------------------------------------------]]
SWEP.CurSpin = 0
SWEP.Percent = 0

function SWEP:SetupDataTables()
	self:AddNWVar('Float', 'Spin')
	self:AddNWVar('Float', 'Delay')

	self:AddDataTables()
end

function SWEP:Precache()
	local data	= self.Primary

	util.PrecacheSound(data.SoundData.snd)
	util.PrecacheSound(data.DryfireData.snd)
	util.PrecacheSound(data.SpinData.snd)

	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.WorldModel)

	self:CustomPrecache()
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)

	local delay = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()

	self:AddDelay(delay)

	self:SetDelay(delay)

	self:OnDeploy()

	return true
end


--[[------------------------------------------------------------------------------------------------------
	Functionality
--------------------------------------------------------------------------------------------------------]]
function SWEP:CanPrimaryAttack()
	if not self:AmmoCheck() then return false end

	local data	= self.Primary
	local spin	= data.SpinData
	local owner	= self:GetOwner()
	local delay	= CurTime() + data.Delay

	if owner:KeyDown(IN_ATTACK) and self:GetSpin() < data.MaxSpin then
		self:AddDelay(delay)

		self:EmitCustomSound(spin.snd, spin.vol, spin.pit)

		local vm = owner:GetViewModel()
		local anim = vm:SelectWeightedSequence(ACT_VM_IDLE)

		vm:SendViewModelMatchingSequence(anim)
	end

	return self:GetSpin() == data.MaxSpin
end

function SWEP:Think()
	self:WeaponThink()

	self:LimitAmmo()

	local data = self.Primary

	self.Percent	= math.Round(self.CurSpin / data.MaxSpin * 100)
	self.ExtraText	= 'Spin: ' .. self.Percent .. '%'

	local FT = FrameTime()

	self:SetSpin(self.CurSpin)

	if self:GetDelay() > CurTime() then
		self.CurSpin = math.Approach(self.CurSpin, 0, data.SpinSpd * 0.25 * FT)

		return
	end

	if self:GetOwner():KeyDown(IN_ATTACK) then
		self.CurSpin = math.Approach(self.CurSpin, data.MaxSpin, data.SpinSpd * FT)
	else
		self.CurSpin = math.Approach(self.CurSpin, 0, data.SpinSpd * 0.25 * FT)
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
		self.AmmoDisplay.PrimaryAmmo = self.Percent

		return self.AmmoDisplay
	end
end