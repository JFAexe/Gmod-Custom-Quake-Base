AddCSLuaFile()

-- CQB_register_base(filename)	-- Such a hacky way to fix hud and maybe smth else?

-- CQB_add_sound(name, path)	-- Faster sound.Add

-- CQB_add_killicon('cqb_template', 'S T O L E N  C O D E ™')	-- Fast killicon

SWEP.Base					= 'cqb_base' -- cqb_base / cqb_spin_base / cqb_burst_base

SWEP.Category				= 'S T O L E N  C O D E ™'
SWEP.PrintName				= 'cqb_template'

SWEP.Author 				= 'JFAexe'

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false
SWEP.AdminOnly 				= false

SWEP.Slot 					= 1
SWEP.SlotPos 				= 0

SWEP.DrawCrosshair			= false
SWEP.DrawAmmo 				= false


-- Primary
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
SWEP.Primary.SpinData		= {	-- Spin base only
	snd = Sound('weapons/galil/galil_boltpull.wav'),
	vol = 45,
	pit = 80
}
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.RPM			= 800
SWEP.Primary.HorizSpread	= 2
SWEP.Primary.VertSpread		= 0
SWEP.Primary.Recoil			= 0.7
SWEP.Primary.Force			= 0.5
SWEP.Primary.DamageType		= DMG_BULLET


-- Ammo
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.TakeAmmo		= 1
SWEP.Primary.AmmoLimit		= false
SWEP.Primary.MaxAmmo		= 100
SWEP.Primary.Ammo			= 'SMG1'


-- View model
SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.UseHands				= false
SWEP.ViewModel				= 'models/weapons/cstrike/c_rif_ak47.mdl'
SWEP.VMPos					= Vector(0, 0, 0)
SWEP.VMAng					= Angle(0, 0, 0)
SWEP.AltVMPos				= Vector(0, 0, 0)
SWEP.AltVMAng				= Angle(0, 0, 0)


-- World model
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


-- SCK
SWEP.ViewModelBoneMods		= {}
SWEP.VElements				= {}
SWEP.WElements				= {}


-- Special options
SWEP.XMuzzleflash			= false
SWEP.DisableMuzzleflash		= false
SWEP.DisableShells			= false

SWEP.XMuzzleflashSize		= 1
SWEP.TracerEffect			= 'tracer'

SWEP.Heavy					= false
SWEP.SpeedMultiply			= 1

SWEP.ExtraText				= ''


-- Spin base only
SWEP.MaxSpin				= 10
SWEP.SpinSpd				= 10


-- Burst base only
SWEP.BurstShots				= 3


-- Callbacks
function SWEP:AddDataTables()
	return
end

function SWEP:CustomPrecache()
	return
end

function SWEP:OnInitialize()
	return
end

function SWEP:OnDeploy()
	return
end

function SWEP:OnHolster()
	return
end

function SWEP:WeaponThink()
	return
end

function SWEP:OnPreDrawViewModel(vm)
	return
end

function SWEP:OnPostDrawViewModel(vm)
	return
end


-- Replacements
--[[
	function SWEP:CanPrimaryAttack()
		return true
	end

	function SWEP:ShootBullet()
		return
	end

	function SWEP:SecondaryAttack()
		return
	end

	function SWEP:Reload()
		return
	end
]]