AddCSLuaFile()

CQB_register_base('cqb_burst_base')

SWEP.Base					= 'cqb_base'

SWEP.Category				= 'S T O L E N  C O D E ™'
SWEP.PrintName				= 'cqb_burst_base'

SWEP.Author					= 'JFAexe'

SWEP.Spawnable				= false

SWEP.BurstShots				= 3


--[[------------------------------------------------------------------------------------------------------
	Functionality
--------------------------------------------------------------------------------------------------------]]
SWEP.BurstCount = 0
SWEP.BurstTimer = 0

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self.BurstTimer = CurTime()
	self.BurstCount = self.BurstShots

	self:AddDelay(CurTime() + (self.Primary.Delay * self.BurstShots) + 0.05)

	return
end

function SWEP:Think()
	self:WeaponThink()

    self:LimitAmmo()

    if self.BurstTimer + self.Primary.Delay < CurTime() and self.BurstCount > 0 then
		self.BurstCount = self.BurstCount - 1
		self.BurstTimer = CurTime()

		self:Attack()
	end
end