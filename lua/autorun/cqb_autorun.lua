-- Hate making autoruns.

--[[------------------------------------------------------------------------------------------------------
	Fonts / Con vars / Functions
--------------------------------------------------------------------------------------------------------]]
CQB_base_types = {}

function CQB_register_base(name)
	CQB_base_types[name] = true
end

function CQB_add_sound(name, path)
	sound.Add({
		name    = name,
		channel = CHAN_ITEM,
		volume  = 1.0,
		sound   = path
	})
end

local CreateClConv = CreateClientConVar

local function AddClConv(name, def, min, max)
	CreateClConv(name, def, true, false, nil, min, max)
end

AddClConv('cqb_viewbob', 1, 0, 1)
AddClConv('cqb_altpos', 0, 0, 1)
AddClConv('cqb_hud_enabled', 1, 0, 1)
AddClConv('cqb_hud_crosshair', 1, 0, 1)
AddClConv('cqb_hud_crosshairstyle', 1, 1, 8)
AddClConv('cqb_hud_x', 0.25, 0.25, 0.4)
AddClConv('cqb_hud_y', 0.15, 0.15, 0.6)

if CLIENT then
	local NewFont = surface.CreateFont

	local _font, _weight, _anta = 'DermaLarge', 800, true

	NewFont(
		'CQBLarge',
		{ font = _font, weight = _weight, size = ScreenScale(18), antialiasing = _anta }
	)
	NewFont(
		'CQBMedium',
		{ font = _font, weight = _weight, size = ScreenScale(10), antialiasing = _anta }
	)
	NewFont(
		'CQBSmall',
		{ font = _font, weight = _weight, size = ScreenScale(8), antialiasing = _anta }
	)
	NewFont(
		'CQBMicro',
		{ font = _font, weight = _weight, size = ScreenScale(7), antialiasing = _anta }
	)
	NewFont(
		'CQBKill',
		{ font = _font, weight = _weight, size = ScreenScale(8), antialiasing = _anta, additive = true }
	)
end


--[[------------------------------------------------------------------------------------------------------
	HUD
--------------------------------------------------------------------------------------------------------]]
local ply, wep

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

    if CQB_base_types[wep.Base] then
        if HideElements[name] then return not GetConVar('cqb_hud_enabled'):GetBool() end
    end
end)


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
			panel:NumSlider('Crosshair style', 'cqb_hud_crosshairstyle', 1, 8, 0)

			panel:CheckBox('HUD', 'cqb_hud_enabled')
			panel:NumSlider('HUD Horizontal modifier', 'cqb_hud_x', 0.25, 0.4)
			panel:NumSlider('HUD Vertical modifier', 'cqb_hud_y', 0.15, 0.6)

			panel:Help('\nv1.2 by JFAexe')
		end)
	end)
end