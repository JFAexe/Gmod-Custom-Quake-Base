AddCSLuaFile()

CQB_add_killicon_text('cqb_ent_grenade', 'TOUCHED')

ENT.Base      = 'cqb_ent_explosive_base'
ENT.Type      = 'anim'
ENT.PrintName = 'cqb_ent_grenade'

ENT.Author    = 'JFAexe'
ENT.Category  = 'S T O L E N  C O D E ™'
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.Model     = 'models/Items/AR2_Grenade.mdl'
ENT.Scale     = 2

function ENT:OnPhysicsCollide(data, phys)
    self:Explode()
end