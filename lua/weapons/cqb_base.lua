AddCSLuaFile()

-- Custom Quake base (now all in one)
-- And now it's a complex mess...

--[[------------------------------------------------------------------------------------------------------
    Necessary info
--------------------------------------------------------------------------------------------------------]]
SWEP.Base                   = 'weapon_base'

SWEP.Category               = 'S T O L E N  C O D E ™'
SWEP.PrintName              = 'cqb_base'

SWEP.Author                 = 'JFAexe'

SWEP.Spawnable              = false
SWEP.AdminSpawnable         = false
SWEP.AdminOnly              = false

SWEP.Slot                   = 0
SWEP.SlotPos                = 0

SWEP.DrawCrosshair          = true
SWEP.DrawAmmo               = true


--[[------------------------------------------------------------------------------------------------------
    Sounds
--------------------------------------------------------------------------------------------------------]]
SWEP.Primary.SoundData      = {
    snd = Sound('weapons/fiveseven/fiveseven-1.wav'),
    vol = 75,
    pit = 90
}
SWEP.Primary.DryfireData    = {
    snd = Sound('weapons/mac10/mac10_boltpull.wav'),
    vol = 70,
    pit = 150
}
SWEP.Primary.SpinData       = {
    snd = Sound('weapons/galil/galil_boltpull.wav'),
    vol = 45,
    pit = 80
}
SWEP.Primary.ZoomData       = {
    snd = Sound('weapons/zoom.wav'),
    vol = 65,
    pit = 160
}
SWEP.Primary.DeployData     = {
    snd = Sound('/ui/hint.wav'),
    vol = 65,
    pit = 160
}


--[[------------------------------------------------------------------------------------------------------
    Attack
--------------------------------------------------------------------------------------------------------]]
SWEP.Primary.Damage         = 20
SWEP.Primary.NumShots       = 1
SWEP.Primary.Automatic      = true
SWEP.Primary.RPM            = 300
SWEP.Primary.HorizSpread    = 1
SWEP.Primary.VertSpread     = 0
SWEP.Primary.Recoil         = 0.7
SWEP.Primary.Force          = 0.5
SWEP.Primary.DamageType     = DMG_BULLET


--[[------------------------------------------------------------------------------------------------------
    Ammo
--------------------------------------------------------------------------------------------------------]]
SWEP.Primary.DefaultClip    = 100
SWEP.Primary.TakeAmmo       = 1
SWEP.Primary.AmmoLimit      = false
SWEP.Primary.MaxAmmo        = 100
SWEP.Primary.Ammo           = 'SMG1'

SWEP.Primary.ClipSize       = -1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.Defaulrclip  = -1
SWEP.Secondary.Ammo         = 'none'


--[[------------------------------------------------------------------------------------------------------
    View Model
--------------------------------------------------------------------------------------------------------]]
SWEP.ViewModelFOV           = 80
SWEP.ViewModelFlip          = false
SWEP.UseHands               = false
SWEP.LightedViewmodel       = false
SWEP.ShowViewModel          = true
SWEP.ViewModel              = 'models/weapons/cstrike/c_rif_ak47.mdl'
SWEP.VMPos                  = Vector(0, 0, 0)
SWEP.VMAng                  = Angle(0, 0, 0)
SWEP.AltVMPos               = Vector(0, 0, 0)
SWEP.AltVMAng               = Angle(0, 0, 0)

SWEP.SwayScale              = 0
SWEP.BobScale               = 0


--[[------------------------------------------------------------------------------------------------------
    World Model
--------------------------------------------------------------------------------------------------------]]
SWEP.WorldModel             = 'models/weapons/w_rif_ak47.mdl'
SWEP.HoldType               = 'ar2'
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

SWEP.Heavy                  = false
SWEP.SpeedMultiply          = 1


--[[------------------------------------------------------------------------------------------------------
    Effects
--------------------------------------------------------------------------------------------------------]]
SWEP.DisableMuzzleflash     = false
SWEP.DisableShells          = true

SWEP.XMuzzleflash           = false
SWEP.CustomMuzzleflash      = false

SWEP.XMuzzleflashSize       = 1
SWEP.TracerEffect           = 'tracer'
SWEP.MuzzleflashEffect      = ''

SWEP.LuaShells              = true
SWEP.ShellCasing            = 'rifle'
SWEP.ShellAtt               = 2
SWEP.ShellLeftAtt           = 4
SWEP.ShellInvertAng         = false
SWEP.ShellPosAdjust         = Vector(0, 0, 0)
SWEP.ShellScale             = 1
SWEP.ShellSpeed             = 100


--[[------------------------------------------------------------------------------------------------------
    Burst
--------------------------------------------------------------------------------------------------------]]
SWEP.Burst                  = false
SWEP.BurstShots             = 3
SWEP.BurstDelay             = 0


--[[------------------------------------------------------------------------------------------------------
    Akimbo
--------------------------------------------------------------------------------------------------------]]
SWEP.Dual                   = false
SWEP.Right                  = 'shoot_right1'
SWEP.RightAtt               = 1
SWEP.Left                   = 'shoot_left1'
SWEP.LeftAtt                = 2


--[[------------------------------------------------------------------------------------------------------
    Grenade / rocket launcher
--------------------------------------------------------------------------------------------------------]]
SWEP.Launcher               = false
SWEP.Projectile             = 'cqb_ent_grenade'
SWEP.ProjectileForce        = 1000
SWEP.ProjectileRadius       = 200


--[[------------------------------------------------------------------------------------------------------
    Spinny boi
--------------------------------------------------------------------------------------------------------]]
SWEP.Spin                   = false
SWEP.MaxSpin                = 10
SWEP.SpinSpd                = 10


--[[------------------------------------------------------------------------------------------------------
    Sights go zoom zoom
--------------------------------------------------------------------------------------------------------]]
SWEP.Zoom                   = false
SWEP.SightsFov              = 60
SWEP.SightsTime             = 0.05
SWEP.SightsSensitivity      = 0.55


--[[------------------------------------------------------------------------------------------------------
    Base
--------------------------------------------------------------------------------------------------------]]
local rnd, tbl, pairs, mth = render, table, pairs, math
local Clamp, Rand, Random, Min, App, Round = mth.Clamp, mth.Rand, mth.random, mth.min, mth.Approach, mth.Round

SWEP.IsCQB      = true -- DO NOT TOUCH

SWEP.CurSpin    = 0
SWEP.Percent    = 0
SWEP.BurstCount = 0
SWEP.BurstTimer = 0

function SWEP:AddDelay(delay)
    self:SetNextPrimaryFire(delay)
    self:SetNextSecondaryFire(delay)
end

function SWEP:EmitCustomSound(sound, volume, pitch, chan)
    self:EmitSound(sound, volume, pitch, 1, chan or CHAN_ITEM)
end

SWEP.DataTableReserve = {
    ['String'] = 0,
    ['Bool']   = 0,
    ['Float']  = 0,
    ['Int']    = 0,
    ['Vector'] = 0,
    ['Angle']  = 0,
    ['Entity'] = 0
}

function SWEP:AddNWVar(type, variable)
    if self.DataTableReserve[type] == nil then return end

    self:NetworkVar(type, self.DataTableReserve[type], variable)

    self.DataTableReserve[type] = self.DataTableReserve[type] + 1
end

function SWEP:TargetIsABeing(ent)
    return ent:IsValid() and (ent:IsNPC() or ent:IsPlayer() or type(ent) == 'NextBot')
end

function SWEP:SetupDataTables()
    self:AddNWVar('Bool', 'Sights')
    self:AddNWVar('Float', 'Spin')
    self:AddNWVar('Float', 'Delay')
    self:AddNWVar('Bool', 'Barrel')
    self:AddNWVar('Int', 'Attach')

    self:AddDataTables()
end

function SWEP:AddDataTables()
    return
end

function SWEP:Precache()
    local utlps = util.PrecacheSound
    local utlpm = util.PrecacheModel
    local data = self.Primary

    utlps(data.SoundData.snd)
    utlps(data.DryfireData.snd)
    utlps(data.SpinData.snd)
    utlps(data.ZoomData.snd)
    utlps(data.DeployData.snd)

    utlpm(self.ViewModel)
    utlpm(self.WorldModel)

    self:CustomPrecache()
end

function SWEP:CustomPrecache()
    return
end

function SWEP:Initialize()
    self:Precache()

    self:SetHoldType(self.HoldType)

    self.Primary.Delay = 1 / (self.Primary.RPM / 60)

    if self.Dual then
        self:SetBarrel(true)
        self:SetAttach(self.RightAtt)
    end

    if CLIENT then self:InitSCK() end

    self:OnInitialize()
end

function SWEP:OnInitialize()
    return
end

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW)
    local dpl  = self.Primary.DeployData

    local delay = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
    
    self:EmitCustomSound(dpl.snd, dpl.vol, dpl.pit, CHAN_AUTO)
    
    self:AddDelay(delay)

    self:SetDelay(delay)

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
    if self:GetOwner():IsNPC() then return true end

    if not self.Spin then return self:AmmoCheck() end

    if not self:AmmoCheck() then return false end

    local data  = self.Primary
    local spin  = data.SpinData
    local owner = self:GetOwner()
    local delay = CurTime() + data.Delay

    if owner:KeyDown(IN_ATTACK) and self:GetSpin() < self.MaxSpin then
        self:EmitCustomSound(spin.snd, spin.vol, spin.pit)

        local vm = owner:GetViewModel()
        local anim = vm:SelectWeightedSequence(ACT_VM_IDLE)

        vm:SendViewModelMatchingSequence(anim)

        self:AddDelay(delay)
    end

    return self:GetSpin() >= self.MaxSpin
end

function SWEP:AmmoCheck()
    if CQB_GetConv('cqb_sv_infinite_ammo', 'bool') then return true end

    local data  = self.Primary
    local dry   = data.DryfireData
    local delay = CurTime() + data.Delay

    if self:Ammo1() <= 0 and self:Ammo1() < data.TakeAmmo then
        self:EmitCustomSound(dry.snd, dry.vol, dry.pit)

        self:AddDelay(delay)

        return false
    end

    return true
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end

    if self.Burst and not self:GetOwner():IsNPC() then
        local CT = CurTime()
        local delay = CT + (self.Primary.Delay * self.BurstShots) + self.BurstDelay

        self.BurstTimer = CT + self.BurstDelay
        self.BurstCount = self.BurstShots

        self:AddDelay(delay)
    else
        self:Attack()
    end

    return
end

function SWEP:Attack()
    local data  = self.Primary
    local sound = data.SoundData
    local owner = self:GetOwner()
    local delay = CurTime() + data.Delay

    if not owner:IsNPC() then
        owner:ViewPunchReset()

        self:AttackRecoil()

        self:TakePrimaryAmmo(CQB_GetConv('cqb_sv_infinite_ammo', 'bool') and 0 or data.TakeAmmo)
    end

    self:AttackAnim()

    if IsFirstTimePredicted() then
        self:EmitCustomSound(sound.snd, sound.vol, sound.pit, CHAN_ITEM)

        for i = 1, data.NumShots do
            if self.Launcher then
                self:ShootProjectile()
            else
                self:ShootBullet()
            end
        end
    end

    self:AddDelay(delay)
end

function SWEP:ShootBullet()
    local compensation = not game.SinglePlayer() and CQB_GetConv('cqb_sv_hitreg_compensation', 'bool') and 1 or 0

    local owner = self:GetOwner()
    local data  = self.Primary
    local avec  = owner:GetAimVector()
    local spos  = owner:GetShootPos()

    local Vec = avec:Angle()
    Vec:RotateAroundAxis(Vec:Right(),   Rand(-data.VertSpread, data.VertSpread))
    Vec:RotateAroundAxis(Vec:Up(),      Rand(-data.HorizSpread, data.HorizSpread))
    Vec:RotateAroundAxis(Vec:Forward(), 0)

    local bullet      = {}
    bullet.Damage     = data.Damage
    bullet.Force      = data.Force * 2
    bullet.Tracer     = 1
    bullet.Num        = 1
    bullet.Src        = spos
    bullet.Dir        = avec + Vec:Forward()
    bullet.Spread     = Vector(0, 0, 0)
    bullet.HullSize   = compensation
    bullet.TracerName = self.TracerEffect
    bullet.Callback   = function(attacker, tr, damage)
        damage:SetDamageType(data.DamageType or DMG_BULLET) -- bruh

        self:BulletCallback(attacker, tr, damage)
    end

    owner:FireBullets(bullet)
end

function SWEP:BulletCallback(attacker, tr, damage)
    return
end

function SWEP:ShootProjectile()
    local owner = self:GetOwner()
    local data  = self.Primary
    local spos  = owner:GetShootPos()
    local ea    =  owner:EyeAngles()
    local pos   = spos + ea:Forward() * 5

    local vel = ea + Angle(Rand(-data.VertSpread, data.VertSpread), Rand(-data.HorizSpread, data.HorizSpread), 0)
    vel = vel:Forward() * self.ProjectileForce

    if SERVER then
        fr = ents.Create(self.Projectile)

        if not fr then return end

        fr:SetOwner(owner)
        fr:SetPos(pos)
        fr:SetAngles(ea)
        fr:SetData(data.Damage, self.ProjectileRadius)
        fr:Spawn()
        fr:Activate()

        local phys = fr:GetPhysicsObject()
        if IsValid(phys) then phys:SetVelocity(vel) end
    end
end

function SWEP:AttackAnim()
    local owner = self:GetOwner()

    owner:SetAnimation(PLAYER_ATTACK1)

    if owner:IsNPC() then return end

    if self.Dual then
        self:SendWeaponAnim(ACT_VM_IDLE)

        local vm = owner:GetViewModel()

        if self:GetBarrel() then
            vm:SendViewModelMatchingSequence(vm:LookupSequence(self.Left))
            self:SetAttach(self.LeftAtt)
            self:SetBarrel(false)
        else
            vm:SendViewModelMatchingSequence(vm:LookupSequence(self.Right))
            self:SetAttach(self.RightAtt)
            self:SetBarrel(true)
        end
    else
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    end
end

function SWEP:AttackRecoil()
    local data  = self.Primary
    local owner = self:GetOwner()

    local punch = Rand(-data.Recoil, -data.Recoil * 0.75)

    if self.Dual then
        local att = self:GetAttach() * 0.5
        local pun = self:GetBarrel() and att or -att

        owner:ViewPunchReset()
        owner:ViewPunch(Angle(punch, 0, punch * pun * 0.75))
    else
        owner:ViewPunch(Angle(punch, 0, 0))
    end

    if self.Heavy and CQB_GetConv('cqb_sv_allow_knockback', 'bool') then
        owner:SetVelocity(owner:GetForward() * (data.Force * -100))
    end
end

function SWEP:SecondaryAttack()
    return
end

function SWEP:Reload()
    return
end

function SWEP:Think()
    self:WeaponThink()

    if CQB_GetConv('cqb_sv_allow_ammolimit', 'bool') then
        self:LimitAmmo()
    end

    if self.Burst then self:BurstThink() end
    if self.Spin then self:SpinThink() end
    if self.Zoom then self:ZoomThink() end
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

function SWEP:BurstThink()
    local CT = CurTime()

    if self.BurstTimer + self.Primary.Delay < CT and self.BurstCount > 0 then
        self.BurstCount = self.BurstCount - 1
        self.BurstTimer = CT

        self:Attack()
    end
end

function SWEP:SpinThink()
    self.Percent   = Round(self.CurSpin / self.MaxSpin * 100)
    self.ExtraText = 'Spin: ' .. self.Percent .. '%'

    local FT = FrameTime()

    self:SetSpin(self.CurSpin)

    if self:GetDelay() > CurTime() then
        self.CurSpin = App(self.CurSpin, 0, self.SpinSpd * 0.25 * FT)

        return
    end

    if self:GetOwner():KeyDown(IN_ATTACK) then
        self.CurSpin = App(self.CurSpin, self.MaxSpin, self.SpinSpd * FT)
    else
        self.CurSpin = App(self.CurSpin, 0, self.SpinSpd * 0.25 * FT)
    end
end

function SWEP:ZoomThink()
    local owner = self:GetOwner()
    local zoom  = self.Primary.ZoomData
    local time  = self.SightsTime
    local fov   = self.SightsFov - CQB_GetConv('cqb_extrafov', 'float')

    if owner:KeyDown(IN_ATTACK2) and self:GetDelay() <= CurTime() then
        if not self:GetSights() then
            self:SetSights(true)
            self:EmitCustomSound(zoom.snd, zoom.vol, zoom.pit, CHAN_AUTO)
            owner:SetFOV(fov, time)
        end
    elseif self:GetSights() then
        self:SetSights(false)
        self:EmitCustomSound(zoom.snd, zoom.vol, zoom.pit, CHAN_AUTO)
        owner:SetFOV(0, time)
    end
end

function SWEP:AdjustMouseSensitivity()
    return self:GetSights() and self.SightsSensitivity or 1
end


--[[------------------------------------------------------------------------------------------------------
    NPC support
--------------------------------------------------------------------------------------------------------]]
function SWEP:CanBePickedUpByNPCs()
    return true
end

function SWEP:GetNPCRestTimes()
    local delay = self.Primary.Delay

    return delay, delay * 2
end

function SWEP:GetNPCBurstSettings()
    local bool  = self.Burst
    local count = bool and self.BurstShots or 1

    return count, count, self.Primary.Delay
end

function SWEP:GetNPCBulletSpread(proficiency)
    return proficiency
end


--[[------------------------------------------------------------------------------------------------------
    Effects
--------------------------------------------------------------------------------------------------------]]
SWEP.ShellEvents = {
    [20]   = true,
    [21]   = true,
    [6001] = true
}

SWEP.MuzzleEvents = {
    [5001] = true,
    [5003] = true,
    [5011] = true,
    [5021] = true,
    [5031] = true
}

SWEP.Shells = {}

function SWEP:RegisterShell(name, model, sound)
    self.Shells[name] = {
        model = model,
        sound = sound
    }
end

SWEP:RegisterShell(
    'pistol',
    'models/weapons/shell.mdl',
    { 'player/pl_shell1.wav', 'player/pl_shell2.wav', 'player/pl_shell3.wav' }
)

SWEP:RegisterShell(
    'rifle',
    'models/weapons/rifleshell.mdl',
    { 'player/pl_shell1.wav', 'player/pl_shell2.wav', 'player/pl_shell3.wav' }
)

SWEP:RegisterShell(
    'shotgun',
    'models/weapons/Shotgun_shell.mdl',
    { 'weapons/fx/tink/shotgun_shell1.wav', 'weapons/fx/tink/shotgun_shell2.wav', 'weapons/fx/tink/shotgun_shell3.wav' }
)

function SWEP:FireAnimationEvent(pos, ang, event, name)
    if self:GetOwner():IsNPC() then return end

    local vm = self:GetOwner():GetViewModel()
    local att = self.Dual and self:GetAttach() or mth.floor((event - 4991) / 10)

    if self.ShellEvents[event] then
        if self.LuaShells and CQB_GetConv('cqb_shells', 'bool') then
            self:EmitShell(self.ShellCasing)
        end

        return self.DisableShells
    end

    if self.MuzzleEvents[event] then
        local ef = EffectData()
        ef:SetEntity(vm)
        ef:SetOrigin(pos)
        ef:SetAngles(ang)
        ef:SetAttachment(att)
        ef:SetScale(self.XMuzzleflashSize)

        if self.XMuzzleflash then
            util.Effect('CS_MuzzleFlash_X', ef)
        end

        if self.CustomMuzzleflash then
            util.Effect(self.MuzzleflashEffect, ef)
        end

        return self.DisableMuzzleflash
    end
end

function SWEP:GetTracerOrigin()
    if not self.Dual then return end

    local vm = self:GetOwner():GetViewModel()
    local pos = vm:GetAttachment(self:GetAttach())

    return pos.Pos
end

function SWEP:DoImpactEffect(tr, dmgtype)
    if tr.HitSky then return end

    return true
end

function SWEP:EmitShell(shell) -- Still trying to add features from previous (fucked up) base
    local owner = self:GetOwner()

    if owner:ShouldDrawLocalPlayer() then return end

    local ea  = owner:EyeAngles()
    local pos = self.ShellPosAdjust

    local attach = self.Dual and not self:GetBarrel() and self.ShellLeftAtt or self.ShellAtt

    local vm = owner:GetViewModel()
    local att = vm:GetAttachment(attach)

    local dir = self.ShellInvertAng and -att.Ang:Forward() or att.Ang:Forward()

    att.Pos = att.Pos + pos.x * ea:Right()
    att.Pos = att.Pos + pos.y * ea:Forward()
    att.Pos = att.Pos + pos.z * ea:Up()

    self:MakeShell(shell, att.Pos + dir, ea, dir * (self.ShellSpeed or 120))
end

function SWEP:MakeShell(shelltype, pos, ang, vel)
    local angVel = Vector(0, 0, 0)

    vel   = vel or Vector(0, 0, -100)
    vel.x = vel.x + Rand(-8, 8)
    vel.y = vel.y + Rand(-8, 8)
    vel.z = vel.z + Rand(-8, 8)

    angVel.x = Random(-500, 500)
    angVel.y = Random(-500, 500)
    angVel.z = Random(-500, 500)

    local shell      = self.Shells[shelltype]
    local time       = 0
    local removetime = CQB_GetConv('cqb_shellstime', 'float')

    local ent = ClientsideModel(shell.model, RENDERGROUP_BOTH)
    ent:SetPos(pos)
    ent:PhysicsInitBox(Vector(-0.5, -0.15, -0.5), Vector(0.5, 0.15, 0.5))
    ent:SetAngles(ang)
    ent:SetModelScale(self.ShellScale, 0)
    ent:SetMoveType(MOVETYPE_VPHYSICS)
    ent:SetSolid(SOLID_VPHYSICS)
    ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

    local phys = ent:GetPhysicsObject()
    phys:SetMaterial('gmod_silent')
    phys:SetMass(10)
    phys:SetVelocity(vel)
    phys:AddAngleVelocity(ang:Right() * 100 + angVel)

    timer.Simple(time, function()
        local sndt = shell.sound
        local snd  = (type(sndt) == 'table') and sndt[Random(#sndt)] or sndt

        if IsValid(ent) then sound.Play(snd, ent:GetPos()) end
    end)

    SafeRemoveEntityDelayed(ent, removetime)
end


--[[------------------------------------------------------------------------------------------------------
    VM
--------------------------------------------------------------------------------------------------------]]
local VMAnimation, VMBob     = 0, 0
local SwayMod, LeanMod, Lean = 3, 1.4, 1
local SwayAng, SwayAngFin    = Angle(), Angle()

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

    SwayAngFin = LerpAngle(Clamp(FT * 4, 0, 1), SwayAngFin, angdelta * (self.ViewModelFlip and -1 or 1))
    SwayAng    = owner:EyeAngles()

    ang:RotateAroundAxis(ang:Right(),   -SwayAngFin.p * SwayMod)
    ang:RotateAroundAxis(ang:Up(),      SwayAngFin.y  * SwayMod)
    ang:RotateAroundAxis(ang:Forward(), SwayAngFin.y  * SwayMod)

    pos = pos + ang:Right() * SwayAngFin.y * SwayMod * 0.5 + ang:Up() * SwayAngFin.p * SwayMod * 0.5
    ang = ang + Angle(0, 0, Lean * 4)

    return pos, ang
end

function SWEP:DoVMPos(pos, ang)
    local bool = CQB_GetConv('cqb_altpos', 'bool')
    local tblp = bool and self.AltVMPos or self.VMPos or Vector()
    local tbla = bool and self.AltVMAng or self.VMAng or Angle()

    ang:RotateAroundAxis(ang:Right(),   tbla.p)
    ang:RotateAroundAxis(ang:Up(),      tbla.y)
    ang:RotateAroundAxis(ang:Forward(), tbla.r)

    pos = pos + ang:Forward() * tblp.y
    pos = pos + ang:Right()   * tblp.x
    pos = pos + ang:Up()      * tblp.z

    return pos, ang
end

function SWEP:GetViewModelPosition(pos, ang)
    local owner = self:GetOwner()

    if not owner:IsValid() then return pos, ang end

    local FT      = Min(RealFrameTime(), FrameTime()) -- is this even legal?
    local CalcVel = Clamp(owner:GetVelocity():Length() / 600, 0 , 3) / self.SpeedMultiply

    if owner:OnGround() then
        VMAnimation = Lerp(FT * 4, VMAnimation, mth.sin(CurTime() * 8) * CalcVel)
    else
        VMAnimation = Lerp(0.1, VMAnimation, 0)
    end

    pos = pos + ang:Forward() * VMAnimation * 5
    pos = pos + ang:Up() * VMAnimation * 1.25 -- Dusky

    pos, ang = self:DoVMPos(pos, ang)

    if CQB_GetConv('cqb_fancyvm', 'bool') then
        pos, ang = self:SwayVMPos(pos, ang, FT)
    end

    return pos, ang
end

function SWEP:PreDrawViewModel(vm)
    rnd.PushFilterMag(TEXFILTER.POINT) -- retro
    rnd.PushFilterMin(TEXFILTER.POINT) -- ish

    rnd.SuppressEngineLighting(self.LightedViewmodel)

    if not self.ShowViewModel then rnd.SetBlend(0) end

    self:OnPreDrawViewModel(vm)
end

function SWEP:OnPreDrawViewModel(vm)
    return
end

function SWEP:PostDrawViewModel(vm)
    rnd.SuppressEngineLighting(false)
    rnd.SetBlend(1)

    rnd.PopFilterMag()
    rnd.PopFilterMin()

    self:OnPostDrawViewModel(vm)
end

function SWEP:OnPostDrawViewModel(vm)
    return
end


--[[------------------------------------------------------------------------------------------------------
    View
--------------------------------------------------------------------------------------------------------]]
function SWEP:CalcView(ply, origin, angles, fov)
    fov = fov + CQB_GetConv('cqb_extrafov', 'float')

    if IsFirstTimePredicted() or not CQB_GetConv('cqb_viewbob', 'bool') then
        return origin, angles, fov
    end

    local FT, owner = Min(RealFrameTime(), FrameTime()), self:GetOwner()

    if owner:KeyDown(IN_MOVERIGHT) then
        VMBob = Lerp(FT * 6, VMBob, owner:GetVelocity():Length() * 0.005)
    elseif owner:KeyDown(IN_MOVELEFT) then
        VMBob = Lerp(FT * 6, VMBob, -owner:GetVelocity():Length() * 0.005)
    else
        VMBob = Lerp(FT * 6, VMBob, 0)
    end

    angles = angles + Angle(VMAnimation * -2.5, 0, VMBob)

    return origin, angles, fov
end


--[[------------------------------------------------------------------------------------------------------
    HUD
--------------------------------------------------------------------------------------------------------]]
if CLIENT then
    function SWEP:DrawCrosshair()
        if not CQB_GetConv('cqb_hud_crosshair', 'bool') then return end

        local styles = CQB_CrosshairStyles
        local cross  = ' '

        for i = 0, Round(self.Primary.HorizSpread * 2) do cross = cross .. ' ' end

        local _style = CQB_GetConv('cqb_hud_crosshairstyle', 'int')
        local _stll  = styles.l[_style]
        local _stlr  = styles.r[_style]
        local _cross = _stll .. cross .. _stlr

        local bool   = self:GetSights()
        local _zooml = bool and _stll or ''
        local _zoomr = bool and _stlr or ''

        local _zoom = _zooml .. _cross .. _zoomr

        local text = self.Zoom and _zoom or _cross
        local w, h = CQB_TextSize(text, 'CQBCross')

        CQB_ShadowText(text, 'CQBCross', CQB_swc - w * 0.5, CQB_shc - 2 - h * 0.45, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        if not bool then return end

        CQB_CrossDot()
    end

    function SWEP:DrawHUD()
        local owner = self:GetOwner()

        self:DrawCrosshair()
        self:DrawCustomHUD()

        if not CQB_GetConv('cqb_hud_enabled', 'bool') then return end

        local _x   = CQB_GetConv('cqb_hud_x', 'float')
        local horz = CQB_swc * _x
        local lcl  = CQB_swc - horz
        local rcl  = CQB_swc + horz

        local _y   = CQB_GetConv('cqb_hud_y', 'float')
        local cus  = CQB_sh - CQB_shc * (_y + 0.3)
        local top  = CQB_sh - CQB_shc * (_y + 0.22)
        local mid  = CQB_sh - CQB_shc * (_y + 0.1)
        local bot  = CQB_sh - CQB_shc * _y

        local healthcolor = CQB_ColorFade(CQB_ColWH, CQB_ColRd, Clamp(owner:Health() / owner:GetMaxHealth(), 0, 1))

        CQB_ShadowText('Armor', 'CQBSmall', lcl, top, nil, TEXT_ALIGN_TOP)
        CQB_ShadowText(CQB_format(owner:Armor()), 'CQBLarge', lcl, mid)

        CQB_ShadowText(CQB_TextLimit(horz * 0.6, owner:Nick(), 'CQBSmall'), 'CQBSmall', rcl, top, nil, TEXT_ALIGN_TOP)
        CQB_ShadowTextColor(CQB_format(owner:Health()), 'CQBLarge', rcl, mid, healthcolor)

        CQB_ShadowText(CQB_TextLimit(horz * 1.4, self.PrintName, 'CQBMedium'), 'CQBMedium', CQB_swc, top)

        if self.DrawAmmo then
            local ammo = self:Ammo1()
            local ammocol = CQB_ColorFade(CQB_ColWH, CQB_ColRd, ammo > 0 and 1 or 0)

            CQB_ShadowTextColor(ammo, 'CQBLarge', CQB_swc, mid, ammocol)
            CQB_ShadowText(self.Primary.Ammo, 'CQBSmall', CQB_swc, bot)
        end

        CQB_ShadowText(self.ExtraText or '', 'CQBSmall', CQB_swc, cus)
    end

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
        self.VElements = tbl.FullCopy(self.VElements)
        self.WElements = tbl.FullCopy(self.WElements)
        self.ViewModelBoneMods = tbl.FullCopy(self.ViewModelBoneMods)
        self:CreateModels(self.VElements)
        self:CreateModels(self.WElements)

        if IsValid(owner) and owner:IsPlayer() then
            local vm = owner:GetViewModel()

            if IsValid(vm) then self:ResetBonePositions(vm) end
        end
    end
end

function SWEP:HolsterSCK()
    local owner = self:GetOwner()

    if CLIENT and IsValid(owner) and owner:IsPlayer() then
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
                    tbl.insert(self.vRenderOrder, 1, k)
                elseif (v.type == 'Sprite' or v.type == 'Quad') then
                    tbl.insert(self.vRenderOrder, k)
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
                    rnd.SuppressEngineLighting(true)
                end

                rnd.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
                rnd.SetBlend(v.color.a / 255)
                model:DrawModel()
                rnd.SetBlend(1)
                rnd.SetColorModulation(1, 1, 1)

                if (v.surpresslightning) then
                    rnd.SuppressEngineLighting(false)
                end
            elseif (v.type == 'Sprite' and sprite) then
                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                rnd.SetMaterial(sprite)
                rnd.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
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
                    tbl.insert(self.wRenderOrder, 1, k)
                elseif (v.type == 'Sprite' or v.type == 'Quad') then
                    tbl.insert(self.wRenderOrder, k)
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
                    rnd.SuppressEngineLighting(true)
                end

                rnd.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
                rnd.SetBlend(v.color.a / 255)
                model:DrawModel()
                rnd.SetBlend(1)
                rnd.SetColorModulation(1, 1, 1)

                if (v.surpresslightning) then
                    rnd.SuppressEngineLighting(false)
                end
            elseif (v.type == 'Sprite' and sprite) then
                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                rnd.SetMaterial(sprite)
                rnd.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
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

    function tbl.FullCopy(tab)
        if (not tab) then return nil end
        local res = {}

        for k, v in pairs(tab) do
            if (type(v) == 'table') then
                res[k] = tbl.FullCopy(v)
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

-- JFAexe was here
