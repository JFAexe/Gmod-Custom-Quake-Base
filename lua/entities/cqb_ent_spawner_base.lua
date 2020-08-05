AddCSLuaFile()

-- Custom Quake Entity base
-- For item spawners

--[[------------------------------------------------------------------------------------------------------
	Necessary info
--------------------------------------------------------------------------------------------------------]]
ENT.Base			= 'base_gmodentity'
ENT.Type			= 'anim'
ENT.PrintName		= 'cqb_ent_spawner_base'

ENT.Author 			= 'JFAexe'
ENT.Category 		= 'S T O L E N  C O D E ™'
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

ENT.BaseModel		= 'models/props_phx/construct/metal_angle360.mdl'
ENT.BaseSkin		= 0
ENT.BaseMaterial	= 'phoenix_storms/stripes'
ENT.BaseColor		= Color(255, 100, 200)
ENT.BaseScale		= 0.4

ENT.Model			= 'models/Items/BoxMRounds.mdl'
ENT.Skin			= 0
ENT.Material		= nil
ENT.Scale			= 1

ENT.AmmoType		= 'Pistol'
ENT.AmmoAmount		= 100

ENT.ExtraHeight		= 0


--[[------------------------------------------------------------------------------------------------------
	Base
--------------------------------------------------------------------------------------------------------]]
local ColorWhite	= Color(255, 255, 255, 255)
local ColorRed		= Color(255, 0, 0, 255)

ENT.RespawnTime		= 0
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT
ENT.DrawingModel	= nil

function ENT:SetupDataTables()
    self:NetworkVar('Float', 0, 'Timer')
end

function ENT:Initialize()
	self:SetModel(self.BaseModel)
	self:SetModelScale(self.BaseScale)
	self:SetMaterial(self.BaseMaterial)
	self:SetColor(self.BaseColor)

	self:DrawShadow(false)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	self:PhysWake()
	self:Activate()

	if SERVER then self:SetTrigger(true) end

	self:CreateClientModel()

	self:SetTimer(CurTime())
end

function ENT:CreateClientModel()
	if CLIENT then
		self.DrawingModel = ClientsideModel(self.Model, self.RenderGroup)
	
		local Model = self.DrawingModel

		Model:SetSkin(self.Skin)
		Model:SetMaterial(self.Material)
		Model:SetModelScale(self.Scale)
		Model:AddEffects(EF_ITEM_BLINK)
	end
end

function ENT:Think()
	self.RespawnTime = CQB_GetConv('cqb_sv_spawner_time', 'float')

	if not CLIENT then return end

	local Model = self.DrawingModel

	if CurTime() < self:GetTimer() then
		Model:SetMaterial('models/wireframe')
		Model:SetColor(ColorRed)

		return
	end

	Model:SetMaterial(self.Material)
	Model:SetColor(ColorWhite)
end

function ENT:Touch(ent)
	if ent:IsValid() and ent:IsPlayer() and SERVER and self:GetTimer() < CurTime() then
		self:OnPickup(ent)
		self:SetTimer(CurTime() + self.RespawnTime)
	end
end

function ENT:OnPickup(ent)
	ent:GiveAmmo(self.AmmoAmount, self.AmmoType, false)
end

if CLIENT then
	function ENT:DrawTranslucent()
		self:DrawModel()

		local Model = self.DrawingModel

		local CT = CurTime()

		local angle = (CT * 90) % 360
		local height = math.sin(CT * 3) * 5

		Model:SetPos(self:GetPos() + Vector(0, 0, height + 20 + self.ExtraHeight))
		Model:SetAngles(Angle(0, angle, 0))
	end

	function ENT:OnRemove()
		self.DrawingModel:Remove()
	end
end