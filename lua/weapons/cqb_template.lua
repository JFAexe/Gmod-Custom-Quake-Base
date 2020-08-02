AddCSLuaFile()

-- Custom Quake base template

--[[------------------------------------------------------------------------------------------------------
	Useful functions
--------------------------------------------------------------------------------------------------------]]
--[[
	CQB_add_sound(name, path) -- Faster sound.Add

	CQB_add_killicon_text('cqb_template', 'S T O L E N  C O D E ™') -- Fast killicon with text

	CQB_add_killicon(id) -- Killicon from vgui/killicons/id
]]


--[[------------------------------------------------------------------------------------------------------
	Necessary info
--------------------------------------------------------------------------------------------------------]]
SWEP.Base					= 'cqb_base'

SWEP.Category				= 'S T O L E N  C O D E ™'
SWEP.PrintName				= 'cqb_template'

SWEP.Author 				= 'JFAexe'

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false
SWEP.AdminOnly 				= false

SWEP.Slot 					= 1
SWEP.SlotPos 				= 0


--[[------------------------------------------------------------------------------------------------------
	Sounds
--------------------------------------------------------------------------------------------------------]]
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
SWEP.Primary.SpinData		= {
	snd = Sound('weapons/galil/galil_boltpull.wav'),
	vol = 45,
	pit = 80
}
SWEP.Primary.ZoomData		= {
	snd = Sound('weapons/zoom.wav'),
	vol = 65,
	pit = 160
}


--[[------------------------------------------------------------------------------------------------------
	Attack
--------------------------------------------------------------------------------------------------------]]
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.RPM			= 300
SWEP.Primary.HorizSpread	= 1
SWEP.Primary.VertSpread		= 0
SWEP.Primary.Recoil			= 0.7
SWEP.Primary.Force			= 0.5
SWEP.Primary.DamageType		= DMG_BULLET


--[[------------------------------------------------------------------------------------------------------
	Ammo
--------------------------------------------------------------------------------------------------------]]
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.TakeAmmo		= 1
SWEP.Primary.AmmoLimit		= false
SWEP.Primary.MaxAmmo		= 100
SWEP.Primary.Ammo			= 'SMG1'


--[[------------------------------------------------------------------------------------------------------
	View Model
--------------------------------------------------------------------------------------------------------]]
SWEP.ViewModelFOV			= 80
SWEP.ViewModelFlip			= false
SWEP.UseHands				= false
SWEP.LightedViewmodel		= false
SWEP.ShowViewModel			= true
SWEP.ViewModel				= 'models/weapons/cstrike/c_rif_ak47.mdl'
SWEP.VMPos					= Vector(0, 0, 0)
SWEP.VMAng					= Angle(0, 0, 0)
SWEP.AltVMPos				= Vector(0, 0, 0)
SWEP.AltVMAng				= Angle(0, 0, 0)


--[[------------------------------------------------------------------------------------------------------
	World Model
--------------------------------------------------------------------------------------------------------]]
SWEP.WorldModel				= 'models/weapons/w_rif_ak47.mdl'
SWEP.HoldType				= 'ar2'
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

SWEP.Heavy					= false
SWEP.SpeedMultiply			= 1


--[[------------------------------------------------------------------------------------------------------
	Effects
--------------------------------------------------------------------------------------------------------]]
SWEP.DisableMuzzleflash		= false
SWEP.DisableShells			= true

SWEP.XMuzzleflash			= false
SWEP.CustomMuzzleflash		= false

SWEP.XMuzzleflashSize		= 1
SWEP.TracerEffect			= 'tracer'
SWEP.MuzzleflashEffect		= ''

SWEP.LuaShells				= true
SWEP.ShellCasing			= 'rifle'
SWEP.ShellAtt				= 2
SWEP.ShellLeftAtt			= 4
SWEP.ShellInvertAng			= false
SWEP.ShellPosAdjust			= Vector(0, 0, 0)
SWEP.ShellScale				= 1
SWEP.ShellSpeed				= 100


--[[------------------------------------------------------------------------------------------------------
	Burst
--------------------------------------------------------------------------------------------------------]]
SWEP.Burst					= false
SWEP.BurstShots				= 3
SWEP.BurstDelay				= 0


--[[------------------------------------------------------------------------------------------------------
	Akimbo
--------------------------------------------------------------------------------------------------------]]
SWEP.Dual					= false
SWEP.Right					= 'shoot_right1'
SWEP.RightAtt				= 1
SWEP.Left					= 'shoot_left1'
SWEP.LeftAtt				= 2


--[[------------------------------------------------------------------------------------------------------
	Grenade / rocket launcher
--------------------------------------------------------------------------------------------------------]]
SWEP.Launcher				= false
SWEP.Projectile				= 'cqb_ent_grenade'
SWEP.ProjectileForce		= 1000
SWEP.ProjectileRadius		= 200


--[[------------------------------------------------------------------------------------------------------
	Spinny boi
--------------------------------------------------------------------------------------------------------]]
SWEP.Spin					= false
SWEP.MaxSpin				= 10
SWEP.SpinSpd				= 10


--[[------------------------------------------------------------------------------------------------------
	Sights go zoom zoom
--------------------------------------------------------------------------------------------------------]]
SWEP.Zoom					= false
SWEP.SightsFov				= 60
SWEP.SightsTime				= 0.05
SWEP.SightsSensitivity		= 0.55


--[[------------------------------------------------------------------------------------------------------
	Replacements
	You can replace every function but be careful and try not to touch SCK related stuff

	Functions:
		SWEP:AddDelay(delay) -- Adds Delay for Primary and Secondary attacks
		SWEP:EmitCustomSound(sound, volume, pitch, chan) -- Emits sound with pitch and volume level
		SWEP:AddNWVar(type, variable) -- Used in SWEP:AddDataTables(). Automated.
			(Data types: String, Bool, Float, Int, Vector, Angle, Entity)
		SWEP:TargetIsABeing(ent) -- Checks entity for being a player / npc / nextbot
		SWEP:AmmoCheck() -- Checks ammo reserve
		SWEP:Attack() -- Primary attack abstraction (used in SWEP:PrimaryAttack())
		SWEP:ShootBullet() -- Fires bullet (used in SWEP:Attack())
		SWEP:ShootProjectile() -- Fires projectile (used in SWEP:Attack())
		SWEP:BulletCallback(attacker, tr, damage) -- callback of bullet
		SWEP:AttackAnim() -- Does attack animation (used in SWEP:Attack())
		SWEP:AttackRecoil() -- Does attack recoil (used in SWEP:Attack())
		SWEP:LimitAmmo() -- Limits ammo via think
		SWEP:EmitShell(shell) -- Emits lua shell
		SWEP:RegisterShell(name, model, sound) -- Register LUA shell type
		SWEP:DrawCrosshair() -- Draws crosshair (used in SWEP:DrawHUD())

	Registred NWVars (With Get/Set):
		Sights	(Bool)	-- Zoom
		Spin	(Float)	-- Spin process
		Delay	(Float)	-- Delay for processes
		Barrel	(Bool)	-- Dual weapons barrel flag
		Attach	(Int)	-- Dual weapons shell ejection attachment id

	Misc:
		CQB_GetConv(convar, type) -- Returns var's data (types: bool, int, float)

	HUD Related functions / enums:
		CQB_sw, CQB_sh -- Screen width / height
		CQB_swc, CQB_shc -- Screen center by width / height

		CQB_ColBG -- Color(0, 0, 0, 200)
		CQB_ColWH -- Color(255, 255, 255)

		CQB_TextSize(text, font) -- Returns width / height
		CQB_TextLimit(w, text, font) -- Returns limited text
		CQB_format(var, max) -- Returns limited int (default 999)
		CQB_ShadowText(text, font, x, y, align1, align2) -- Just shadowed text
		CQB_CrossDot() -- Draws dot in center of screen
--------------------------------------------------------------------------------------------------------]]
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

--[[
	SWEP:CanPrimaryAttack()
		return self:AmmoCheck()
	end

	function SWEP:SecondaryAttack()
		return
	end

	function SWEP:Reload()
		return
	end

	function SWEP:DoImpactEffect(tr, dmgtype)
		if tr.HitSky then return end

		return true
	end

	if CLIENT then
		function SWEP:DrawCustomHUD()
			return
		end

		function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
			CQB_ShadowText(CQB_TextLimit(300, self.PrintName, 'CQBMedium'), 'CQBSmall', x + wide * 0.5, y + tall * 0.5 - 10)
		end

		function SWEP:CustomAmmoDisplay()
			self.AmmoDisplay = self.AmmoDisplay or {}

			self.AmmoDisplay.Draw = true

			self.AmmoDisplay.PrimaryClip = self:Ammo1()

			if self.Spin then
				self.AmmoDisplay.PrimaryAmmo = self.Percent
			end

			return self.AmmoDisplay
		end
	end
]]