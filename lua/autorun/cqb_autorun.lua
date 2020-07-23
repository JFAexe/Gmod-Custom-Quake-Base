-- Hate making autoruns.

--[[------------------------------------------------------------------------------------------------------
	Fonts / Con vars
--------------------------------------------------------------------------------------------------------]]
local conv = CreateClientConVar

if CLIENT then
	local newfont = surface.CreateFont

	newfont('HUDLarge',  {font = 'DermaLarge', weight = 800,	size = ScreenScale(18),	antialiasing = true})
	newfont('HUDMedium', {font = 'DermaLarge', weight = 800,	size = ScreenScale(10),	antialiasing = true})
	newfont('HUDSmall',  {font = 'DermaLarge', weight = 800,	size = ScreenScale(8), 	antialiasing = true})
	newfont('HUDMicro',  {font = 'DermaLarge', weight = 800,	size = ScreenScale(7), 	antialiasing = true})
	
	conv('cqb_viewbob',			 	1,	true, false, nil, 0,	1)
	conv('cqb_altpos',			  	0,	true, false, nil, 0,	1)
	conv('cqb_hud_enabled',		 	1,	true, false, nil, 0,	1)
	conv('cqb_hud_crosshair',	   	1,	true, false, nil, 0,	1)
	conv('cqb_hud_crosshairstyle',  1,	true, false, nil, 1,	8)
	conv('cqb_hud_x',			   	0.25, true, false, nil, 0.25, 0.4)
	conv('cqb_hud_y',			   	0.15, true, false, nil, 0.15, 0.6)
end


--[[------------------------------------------------------------------------------------------------------
	HUD
--------------------------------------------------------------------------------------------------------]]
local ply, wep

local _cqb_base_types 	= {
    ['cqb_base']		= true,
    ['cqb_spin_base']	= true
}

local HideElements = {  -- fuck everything
    ['CHudZoom']					= true,
    ['CHudAmmo']					= true,
    ['CHudHealth']				  	= true,
    ['CHudGeiger']				  	= true,
    ['CHudBattery']				 	= true,
    ['CHudCrosshair']			   	= true,
    ['CHUDQuickInfo']			   	= true,
    ['CHudSuitPower']			   	= true,
    ['CHudSquadStatus']			 	= true,
    ['CHudSecondaryAmmo']		   	= true,
    ['CHudPoisonDamageIndicator']   = true,
}

hook.Add('HUDShouldDraw', 'cqb_hud', function(name)
    ply = LocalPlayer()

    if IsValid(ply) and ply:Alive() then
        wep = ply:GetActiveWeapon()
    else
        return
    end

    if _cqb_base_types[wep.Base] then
        if HideElements[name] then return not GetConVar('cqb_hud_enabled'):GetBool() end
    end
end)


--[[------------------------------------------------------------------------------------------------------
	Movement
--------------------------------------------------------------------------------------------------------]]
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
		spawnmenu.AddToolCategory('Options', 'CQB', '#CQB')
	end)

	hook.Add('PopulateToolMenu', 'CQBCustomMenuSettings', function()
		spawnmenu.AddToolMenuOption('Options', 'CQB', 'HUD', '#Client', '', '', function(panel)
			panel:ClearControls()
			
			panel:CheckBox('Alt weapon pos', 'cqb_altpos')

			panel:CheckBox('Viewbob', 'cqb_viewbob')

			panel:CheckBox('Crosshair', 'cqb_hud_crosshair')
			panel:NumSlider('Crosshair style', 'cqb_hud_crosshairstyle', 1, 8, 0)

			panel:CheckBox('HUD', 'cqb_hud_enabled')
			panel:NumSlider('HUD X position', 'cqb_hud_x', 0.25, 0.4)
			panel:NumSlider('HUD Y position', 'cqb_hud_y', 0.15, 0.6)

			panel:Help('by JFAexe')
		end)
	end)
end