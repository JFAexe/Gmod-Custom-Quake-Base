AddCSLuaFile()

CQB_register_base('cqb_zoom_base')

SWEP.Base					= 'cqb_base'

SWEP.Category				= 'S T O L E N  C O D E ™'
SWEP.PrintName				= 'cqb_zoom_base'

SWEP.Author					= 'JFAexe'

SWEP.Spawnable				= false

SWEP.Primary.ZoomData		= {
	snd = Sound('weapons/zoom.wav'),
	vol = 65,
	pit = 160
}

SWEP.SightsFov				= 60
SWEP.SightsTime				= 0.05
SWEP.SightsSensitivity		= 0.55


--[[------------------------------------------------------------------------------------------------------
	Base
--------------------------------------------------------------------------------------------------------]]
function SWEP:SetupDataTables()
	self:AddNWVar('Bool', 'Sights')
	self:AddNWVar('Float', 'Delay')

	self:AddDataTables()
end

function SWEP:Precache()
	local data	= self.Primary

	util.PrecacheSound(data.SoundData.snd)
	util.PrecacheSound(data.DryfireData.snd)
	util.PrecacheSound(data.ZoomData.snd)

	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.WorldModel)

	self:CustomPrecache()
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)

	local delay = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()

	self:AddDelay(delay)

	self:SetDelay(delay)

	self:OnDeploy()

	return true
end


--[[------------------------------------------------------------------------------------------------------
	Functionality
--------------------------------------------------------------------------------------------------------]]
function SWEP:Think()
	self:WeaponThink()

	self:LimitAmmo()

	local owner	= self:GetOwner()
	local zoom	= self.Primary.ZoomData
	local time	= self.SightsTime
	local fov	= self.SightsFov - GetConVar('cqb_extrafov'):GetFloat()

	if owner:KeyDown(IN_ATTACK2) and not (self:GetDelay() > CurTime()) then
		if not self:GetSights() then
			self:SetSights(true)
			self:EmitCustomSound(zoom.snd, zoom.vol, zoom.pit)
			owner:SetFOV(fov, time)
		end
	elseif self:GetSights() then
		self:SetSights(false)
		self:EmitCustomSound(zoom.snd, zoom.vol, zoom.pit)
		owner:SetFOV(0, time)
	end
end

function SWEP:AdjustMouseSensitivity()
	return self:GetSights() and self.SightsSensitivity or 1
end


--[[------------------------------------------------------------------------------------------------------
	HUD
--------------------------------------------------------------------------------------------------------]]
if CLIENT then
	function SWEP:DrawCrosshair()
		if not GetConVar('cqb_hud_crosshair'):GetBool() then return end

		local DrawColor, DrawRect = surface.SetDrawColor, surface.DrawRect

		local styles = CQB_CrosshairStyles
		local cross  = ' '

		for i = 0, math.Round(self.Primary.HorizSpread * 2) do cross = cross .. ' ' end

		local _style = GetConVar('cqb_hud_crosshairstyle'):GetInt()
		local _stll  = styles.l[_style]
		local _stlr  = styles.r[_style]
		local _cross = _stll .. cross .. _stlr
	
		local bool   = self:GetSights()
		local _zooml = bool and _stll or ''
		local _zoomr = bool and _stlr or ''

		CQB_ShadowText(_zooml .. _cross .. _zoomr, 'CQBMicro', CQB_swc, CQB_shc - 1)
		
		if not bool then return end

		DrawColor(CQB_ColBG)
		DrawRect(CQB_swc + 1, CQB_shc + 1, 4, 4)
		DrawColor(CQB_ColWH)
		DrawRect(CQB_swc - 1, CQB_shc - 1, 4, 4)
	end
end