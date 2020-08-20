AddCSLuaFile()

-- Custom Quake base melee template

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
SWEP.Base                   = 'cqb_melee_base'

SWEP.Category               = 'S T O L E N  C O D E ™'
SWEP.PrintName              = 'cqb_melee_template'

SWEP.Author                 = 'JFAexe'

SWEP.Spawnable              = false
SWEP.AdminSpawnable         = false
SWEP.AdminOnly              = false

SWEP.Slot                   = 0
SWEP.SlotPos                = 0


--[[------------------------------------------------------------------------------------------------------
    Sounds
--------------------------------------------------------------------------------------------------------]]
SWEP.Primary.RandPitch      = 20
SWEP.Primary.SoundHitEnemy  = {
    snd = Sound('Weapon_Crowbar.Melee_Hit'),
    vol = 65,
    pit = 90
}
SWEP.Primary.SoundHitWorld  = {
    snd = Sound('Weapon_Crowbar.Melee_HitWorld'),
    vol = 65,
    pit = 90
}
SWEP.Primary.SoundMiss      = {
    snd = Sound('Weapon_Crowbar.Single'),
    vol = 65,
    pit = 90
}


--[[------------------------------------------------------------------------------------------------------
    Attack
--------------------------------------------------------------------------------------------------------]]
SWEP.Primary.Damage         = 20
SWEP.Primary.StabDamage     = 80
SWEP.Primary.DelayMiss      = 0.4
SWEP.Primary.DelayHit       = 0.3
SWEP.Primary.Force          = 10
SWEP.Primary.Distance       = 60
SWEP.Primary.DamageType     = DMG_CLUB

SWEP.AnimMiss               = 'midslash1'
SWEP.AnimHit                = 'stab'
SWEP.AnimStab               = 'stab_miss'

SWEP.ViewPunchMiss          = Angle(0, 0, 0)
SWEP.ViewPunchHit           = Angle(0, 0, 0)
SWEP.ViewPunchStab          = Angle(0, 0, 0)

SWEP.CanStab                = true

SWEP.AttackBounds           = {
    mins = Vector(-16, -16, -16),
    maxs = Vector(16, 16, 16)
}


--[[------------------------------------------------------------------------------------------------------
    View Model
--------------------------------------------------------------------------------------------------------]]
SWEP.ViewModelFOV           = 80
SWEP.ViewModelFlip          = false
SWEP.UseHands               = false
SWEP.LightedViewmodel       = false
SWEP.ShowViewModel          = true
SWEP.ViewModel              = 'models/weapons/c_crowbar.mdl'
SWEP.VMPos                  = Vector(0, 0, 0)
SWEP.VMAng                  = Angle(0, 0, 0)
SWEP.AltVMPos               = Vector(0, 0, 0)
SWEP.AltVMAng               = Angle(0, 0, 0)


--[[------------------------------------------------------------------------------------------------------
    World Model
--------------------------------------------------------------------------------------------------------]]
SWEP.WorldModel             = 'models/weapons/w_crowbar.mdl'
SWEP.HoldType               = 'knife'
SWEP.WorldModelData         = {
    Pos = {
        Up      = 0,
        Right   = 0,
        Forward = 0,
    },
    Ang = {
        Up      = 0,
        Right   = 0,
        Forward = 180
    },
    Scale = 1
}


--[[------------------------------------------------------------------------------------------------------
    SCK
--------------------------------------------------------------------------------------------------------]]
SWEP.ViewModelBoneMods      = {}
SWEP.VElements              = {}
SWEP.WElements              = {}


--[[------------------------------------------------------------------------------------------------------
    Base specific
--------------------------------------------------------------------------------------------------------]]
SWEP.ExtraText              = ''

SWEP.SpeedMultiply          = 1


--[[------------------------------------------------------------------------------------------------------
    Replacements
    You can replace every function but be careful and try not to touch SCK related stuff

    Functions:
        SWEP:AddDelay(delay) -- Adds Delay for Primary and Secondary attacks
        SWEP:EmitCustomSound(sound, volume, pitch, chan) -- Emits sound with pitch and volume level
        SWEP:AddNWVar(type, variable) -- Used in SWEP:AddDataTables(). Automated.
            (Data types: String, Bool, Float, Int, Vector, Angle, Entity)
        SWEP:TargetIsABeing(ent) -- Checks entity for being a player / npc / nextbot
        SWEP:MeleeAttack() -- Does attack
        SWEP:CheckBackstab(ent) -- Checks if backstab is possible

    Misc:
        CQB_GetConv(convar, type) -- Returns var's data (types: bool, int, float)

    HUD Related functions / enums:
        CQB_sw, CQB_sh -- Screen width / height
        CQB_swc, CQB_shc -- Screen center by width / height

        CQB_ColBG -- Color(0, 0, 0, 220)
        CQB_ColWH -- Color(255, 255, 255)
        CQB_ColRd -- Color(255, 0, 0)

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
    function SWEP:CanPrimaryAttack()
        return true
    end

    function SWEP:SecondaryAttack()
        return
    end

    function SWEP:Reload()
        return
    end

    function SWEP:DoImpactEffect(tr, dmgtype)
        if tr.HitSky then return end

        if self:TargetIsABeing(tr.Entity) then
            local ef = EffectData()
            ef:SetOrigin(tr.HitPos)

            util.Effect('BloodImpact', ef, true, true)
        end

        return true
    end

    if CLIENT then
        function SWEP:DrawCustomHUD()
            return
        end

        function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
            CQB_ShadowText(CQB_TextLimit(300, self.PrintName, 'CQBMedium'), 'CQBSmall', x + wide * 0.5, y + tall * 0.5 - 10)
        end
    end
]]