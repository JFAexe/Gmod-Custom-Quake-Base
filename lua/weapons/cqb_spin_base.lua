AddCSLuaFile()

SWEP.Base				   	= 'cqb_base'

SWEP.Category			   	= 'S T O L E N  C O D E ™'
SWEP.PrintName			  	= 'cqb_spin_base'

SWEP.Spawnable			  	= false

SWEP.Author 				= 'JFAexe'

-- My spinny boi
SWEP.SpinSnd  				= Sound('weapons/galil/galil_boltpull.wav')
SWEP.MaxSpin  				= 10
SWEP.SpinSpd  				= 10

local _spin 				= 0

function SWEP:CustomPrecache()
	util.PrecacheSound(self.SpinSnd)
end

function SWEP:AddDataTables()
	self:AddNWVar('Float', 'Spin')
	self:AddNWVar('Float', 'Delay')
end

function SWEP:OnDeploy()
	self:SetDelay(CurTime() + self.Owner:GetViewModel():SequenceDuration())
end

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

function SWEP:WeaponThink()
	self.ExtraText = 'Spin: ' .. math.Round(_spin / self.MaxSpin * 100)  .. '%'

	if self:GetDelay() > CurTime() then return end

	local FT = FrameTime()

	if self.Owner:KeyDown(IN_ATTACK) then
		_spin = math.Approach(_spin, self.MaxSpin, self.SpinSpd * FT)
	else
		_spin = math.Approach(_spin, 0, self.SpinSpd * 0.25 * FT)
	end

	self:SetSpin(_spin)
end