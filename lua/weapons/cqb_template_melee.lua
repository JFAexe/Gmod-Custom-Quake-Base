AddCSLuaFile()

-- CQB_register_base(filename)	-- Such a hacky way to fix hud and maybe smth else?

-- CQB_add_sound(name, path)	-- Faster sound.Add

-- CQB_add_killicon(id) -- From vgui/killicons/id

-- CQB_add_killicon_text('cqb_template', 'S T O L E N  C O D E ™')	-- Fast killicon

SWEP.Base					= 'cqb_melee_base'

SWEP.Category				= 'S T O L E N  C O D E ™'
SWEP.PrintName				= 'cqb_template'

SWEP.Author 				= 'JFAexe'

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false
SWEP.AdminOnly 				= false

SWEP.Slot 					= 0
SWEP.SlotPos 				= 0


-- Primary
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
SWEP.Primary.Damage			= 10
SWEP.Primary.Automatic		= true
SWEP.Primary.DelayMiss		= 0.4
SWEP.Primary.DelayHit		= 0.3
SWEP.Primary.Force			= 10
SWEP.Primary.Distance		= 60
SWEP.Primary.DamageType		= DMG_CLUB


-- View model
SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.UseHands				= false
SWEP.LightedViewmodel		= false
SWEP.ShowViewModel			= true
SWEP.ViewModel				= 'models/weapons/c_crowbar.mdl'
SWEP.VMPos					= Vector(0, 0, 0)
SWEP.VMAng					= Angle(0, 0, 0)
SWEP.AltVMPos				= Vector(0, 0, 0)
SWEP.AltVMAng				= Angle(0, 0, 0)


-- World model
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

SWEP.AnimHit				= ACT_VM_HITCENTER
SWEP.AnimMiss				= ACT_VM_MISSCENTER


-- SCK
SWEP.ViewModelBoneMods		= {}
SWEP.VElements				= {}
SWEP.WElements				= {}


-- Special options
SWEP.Heavy					= false
SWEP.SpeedMultiply			= 1

SWEP.ExtraText				= ''


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
-- You can replace every function
-- but be careful and try not to touch SCK related stuff
-- (examples in bases)