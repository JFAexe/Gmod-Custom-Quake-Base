AddCSLuaFile()

CQB_add_killicon_text('cqb_ent_grenade_bounce', 'TOUCHED')

ENT.Base      = 'cqb_ent_explosive_base'
ENT.Type      = 'anim'
ENT.PrintName = 'cqb_ent_grenade_bounce'

ENT.Author    = 'JFAexe'
ENT.Category  = 'S T O L E N  C O D E ™'
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.Model     = 'models/Items/AR2_Grenade.mdl'
ENT.Scale     = 1.5

ENT.Timer     = 1

function ENT:OnInit()
    self.Timer = CurTime() + self.Timer
end

function ENT:Think()
    if not self.Timer or CurTime() < self.Timer then return end

    if SERVER then self:Explode() end
end

function ENT:PhysicsUpdate()
    return
end

function ENT:OnPhysicsCollide(data, phys)
    self:EmitSound('weapons/flashbang/grenade_hit1.wav')

    phys:ApplyForceCenter(-data.Speed * data.HitNormal * 1.2)
end

function ENT:OnExplode()
    self:Remove()
end

function ENT:StartTouch(ent)
    if ent:IsValid() and (ent:IsNPC() or ent:IsPlayer() or type(ent) == 'NextBot') and SERVER then
        self:Explode()
    end
end