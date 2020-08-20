AddCSLuaFile()

-- Custom Quake Entity base
-- For explosive things

--[[------------------------------------------------------------------------------------------------------
    Necessary info
--------------------------------------------------------------------------------------------------------]]
ENT.Base      = 'base_gmodentity'
ENT.Type      = 'anim'
ENT.PrintName = 'cqb_ent_explosive_base'

ENT.Author    = 'JFAexe'
ENT.Category  = 'S T O L E N  C O D E ™'
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.Model     = 'models/Items/AR2_Grenade.mdl'
ENT.Skin      = 0
ENT.Scale     = 2

ENT.Damage    = 100
ENT.Radius    = 100


--[[------------------------------------------------------------------------------------------------------
    Base
--------------------------------------------------------------------------------------------------------]]
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
    local owner = self:GetOwner()

    if not IsValid(owner) then return self:Remove() end

    self:SetModel(self.Model)
    self:SetSkin(self.Skin)
    self:SetModelScale(self.Scale)

    self:AddEffects(EF_ITEM_BLINK)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveCollide(COLLISION_GROUP_PROJECTILE)
    self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

    local color

    if owner:IsNPC() then
        color = Color(255, 0, 0, 150)
    else
        color = ColorAlpha(owner:GetPlayerColor():ToColor(), 150)
    end

    if SERVER then
        util.SpriteTrail(self, 0, color, true, 0, 16, 2, 0.1, 'trails/smoke.vmt')
    end

    self:OnInit()
end

function ENT:OnInit()
    return
end

function ENT:SetData(dmg, rad)
    if SERVER then
        self.Damage = dmg
        self.Radius = rad
    end
end

function ENT:PhysicsCollide(data, phys)
    self:OnPhysicsCollide(data, phys)
end

function ENT:OnPhysicsCollide(data, phys)
    return
end

function ENT:Explode()
    local owner = self:GetOwner()
    local pos   = self:GetPos()

    local ex = EffectData()
    ex:SetOrigin(pos)
    ex:SetMagnitude(1)

    util.Effect('Explosion', ex)
    util.BlastDamage(owner, owner, pos, self.Radius, self.Damage)
    util.ScreenShake(pos, 10, 5, 1, self.Radius * 0.5)

    self:OnExplode()
end

function ENT:OnExplode()
    self:Remove()
end

if CLIENT then
    function ENT:DrawTranslucent()
        self:DrawModel()
    end
end