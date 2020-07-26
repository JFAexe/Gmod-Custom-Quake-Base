-- Hate making autoruns.

--[[------------------------------------------------------------------------------------------------------
	Con vars / Functions
--------------------------------------------------------------------------------------------------------]]
CQB_base_types = {}

function CQB_register_base(name)
	CQB_base_types[name] = true
end

function CQB_add_sound(name, path)
	sound.Add({
		name	= name,
		channel	= CHAN_ITEM,
		volume	= 1.0,
		sound	= path
	})
end

function CQB_add_killicon(id, name)
	if CLIENT then
		killicon.AddFont(id, 'CQBKill', name, Color(225, 255, 0, 255))
	end
end

local CreateClConv = CreateClientConVar

local function AddClConv(name, def, min, max)
	CreateClConv(name, def, true, false, nil, min, max)
end

AddClConv('cqb_viewbob', 1, 0, 1)
AddClConv('cqb_altpos', 0, 0, 1)
AddClConv('cqb_hud_enabled', 1, 0, 1)
AddClConv('cqb_hud_crosshair', 1, 0, 1)
AddClConv('cqb_hud_crosshairstyle', 1, 1, 11)
AddClConv('cqb_hud_x', 0.25, 0.25, 0.4)
AddClConv('cqb_hud_y', 0.15, 0.15, 0.6)


--[[------------------------------------------------------------------------------------------------------
	Fonts / HUD
--------------------------------------------------------------------------------------------------------]]
if CLIENT then
	local NewFont, Scale = surface.CreateFont, ScreenScale

	local _font, _weight, _anta = 'DermaLarge', 800, true

	NewFont('CQBLarge', {
		font			= _font,
		weight			= _weight,
		size			= Scale(18),
		antialiasing	= _anta
	})
	
	NewFont('CQBMedium', {
		font			= _font,
		weight			= _weight,
		size			= Scale(10),
		antialiasing	= _anta
	})
	
	NewFont('CQBSmall', {
		font			= _font,
		weight			= _weight,
		size			= Scale(8),
		antialiasing	= _anta
	})
	
	NewFont('CQBMicro', {
		font			= _font,
		weight			= _weight,
		size			= Scale(7),
		antialiasing	= _anta
	})
	
	NewFont('CQBKill', {
		font			= _font,
		weight			= _weight,
		size			= Scale(8),
		antialiasing	= _anta,
		additive		= true
	})

	CQB_sw, CQB_sh = ScrW(), ScrH()
	CQB_swc, CQB_shc = CQB_sw * 0.5, CQB_sh * 0.5

	CQB_ColBG = Color(0, 0, 0, 200)
	CQB_ColWH = Color(255, 255, 255)

	local SimpleText = draw.SimpleText

	function CQB_format(var, max)
		local max = max or 999

		return (var > max and max) or var
	end

	function CQB_ShadowText(text, font, x, y)
		SimpleText(text, font, x + 2, y + 2, CQB_ColBG, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		SimpleText(text, font, x, y, CQB_ColWH, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local ply, wep

	local HideElements = {  -- fuck everything
		['CHudZoom']					= true,
		['CHudAmmo']					= true,
		['CHudHealth']					= true,
		['CHudGeiger']					= true,
		['CHudBattery']					= true,
		['CHUDQuickInfo']				= true,
		['CHudSuitPower']				= true,
		['CHudSquadStatus']				= true,
		['CHudSecondaryAmmo']			= true,
		['CHudPoisonDamageIndicator']	= true,
	}

	hook.Add('HUDShouldDraw', 'cqb_hud_hide', function(name)
		ply = LocalPlayer()

		if IsValid(ply) and ply:Alive() then
			wep = ply:GetActiveWeapon()
		else
			return
		end

		if not CQB_base_types[wep.Base] then return end

		if name == 'CHudCrosshair' then
			return not GetConVar('cqb_hud_crosshair'):GetBool()
		end

		if HideElements[name] then
			return not GetConVar('cqb_hud_enabled'):GetBool()
		end
	end)

	hook.Add('OnScreenSizeChanged', 'cqb_unfuck_hud', function(w, h)
		CQB_sw, CQB_sh = ScrW(), ScrH()
		CQB_swc, CQB_shc = CQB_sw * 0.5, CQB_sh * 0.5
	end)
end


--[[------------------------------------------------------------------------------------------------------
	Movement
--------------------------------------------------------------------------------------------------------]]
local band, bor, bnot = bit.band, bit.bor, bit.bnot

hook.Add('SetupMove', 'CQB_SetupMove', function(ply, cmd)
	if not ply:Alive() then return end

	wep = ply:GetActiveWeapon()

	if not CQB_base_types[wep.Base] then return end

	if ply:InVehicle() then return end

	if ply:WaterLevel() > 1  then return end

	if  ply:GetMoveType() == MOVETYPE_WALK and band(cmd:GetButtons(), IN_JUMP) == IN_JUMP then
		if ply:IsOnGround() then
			cmd:SetButtons(bor(cmd:GetButtons(), IN_JUMP))
		else
			cmd:SetButtons(band(cmd:GetButtons(), bnot(IN_JUMP)))
		end
	end
end)

hook.Add('Move', 'CQB_Move', function(ply, mv, usrcmd)
	wep = ply:GetActiveWeapon()

	if not (IsValid(wep) and wep.Base == 'cqb_base') then return end

	local speed = mv:GetMaxSpeed() * wep.SpeedMultiply

	mv:SetMaxSpeed(speed)
	mv:SetMaxClientSpeed(speed)
end)


--[[------------------------------------------------------------------------------------------------------
	Menu
--------------------------------------------------------------------------------------------------------]]
if CLIENT then
	hook.Add('AddToolMenuCategories', 'CQBCustomCategory', function()
		spawnmenu.AddToolCategory('Options', 'CQB', '#Custom Quake Base')
	end)

	hook.Add('PopulateToolMenu', 'CQBCustomMenuSettings', function()
		spawnmenu.AddToolMenuOption('Options', 'CQB', 'HUD', '#Client', '', '', function(panel)
			panel:ClearControls()
			
			panel:CheckBox('Alt weapon pos', 'cqb_altpos')

			panel:CheckBox('Viewbob', 'cqb_viewbob')

			panel:CheckBox('Crosshair', 'cqb_hud_crosshair')
			panel:NumSlider('Crosshair style', 'cqb_hud_crosshairstyle', 1, 11, 0)

			panel:CheckBox('HUD', 'cqb_hud_enabled')
			panel:NumSlider('HUD Horizontal modifier', 'cqb_hud_x', 0.25, 0.4)
			panel:NumSlider('HUD Vertical modifier', 'cqb_hud_y', 0.15, 0.6)

			panel:Help('\nv1.3 by JFAexe')
		end)
	end)
end