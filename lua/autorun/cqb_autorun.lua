-- Hate making autoruns.

resource.AddFile('resource/fonts/duskfont.ttf')

local band, bor, bnot = bit.band, bit.bor, bit.bnot
local CreateClConv, CreateConv, GetConv = CreateClientConVar, CreateConVar, GetConVar

--[[------------------------------------------------------------------------------------------------------
	SHARED
--------------------------------------------------------------------------------------------------------]]
function CQB_add_sound(name, path)
	sound.Add({
		name	= name,
		channel	= CHAN_WEAPON,
		volume	= 1.0,
		sound	= path
	})
end

function CQB_add_killicon(id)
	return CLIENT and killicon.Add(id, 'vgui/killicons/' .. id, Color(255, 10, 15, 255))
end

function CQB_add_killicon_text(id, name)
	return CLIENT and killicon.AddFont(id, 'CQBKill', name, Color(255, 10, 15, 255))
end


--[[------------------------------------------------------------------------------------------------------
	Con Vars
--------------------------------------------------------------------------------------------------------]]
function CQB_GetConv(convar, type)
	local case = {
		['int'] = function(var) return var:GetInt() end,
		['bool'] = function(var) return var:GetBool() end,
		['float'] = function(var) return var:GetFloat() end,
	}

	return case[type](GetConv(convar))
end

local function AddClConv(name, def, min, max)
	return CLIENT and CreateClConv(name, def, true, false, nil, min, max)
end

AddClConv('cqb_viewbob', 1, 0, 1)
AddClConv('cqb_extrafov', 0, -5, 20)
AddClConv('cqb_altpos', 0, 0, 1)
AddClConv('cqb_fancyvm', 1, 0, 1)
AddClConv('cqb_shells', 1, 0, 1)
AddClConv('cqb_shellstime', 2, 2, 20)
AddClConv('cqb_hud_enabled', 1, 0, 1)
AddClConv('cqb_hud_crosshair', 1, 0, 1)
AddClConv('cqb_hud_crosshairstyle', 1, 1, 11)
AddClConv('cqb_hud_x', 0.25, 0.25, 0.4)
AddClConv('cqb_hud_y', 0.15, 0.1, 0.6)

local function AddSVConv(name, def, min, max)
	return SERVER and CreateConv(name, def, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY }, nil, min, max)
end

AddSVConv('cqb_sv_allow_customspeed', 1, 0, 1)
AddSVConv('cqb_sv_allow_bhop', 1, 0, 1)
AddSVConv('cqb_sv_allow_knockback', 1, 0, 1)
AddSVConv('cqb_sv_allow_ammolimit', 1, 0, 1)
AddSVConv('cqb_sv_infinite_ammo', 0, 0, 1)
AddSVConv('cqb_sv_spawner_time', 8, 1, 30)


--[[------------------------------------------------------------------------------------------------------
	Hooks
--------------------------------------------------------------------------------------------------------]]
hook.Add('SetupMove', 'CQB_SetupMove', function(ply, cmd)
	if not CQB_GetConv('cqb_sv_allow_bhop', 'bool') then return end

	if not ply:Alive() then return end

	wep = ply:GetActiveWeapon()

	if not (IsValid(wep) and wep.IsCQB) then return end

	if (ply:WaterLevel() > 1 or ply:InVehicle()) then return end

	if  ply:GetMoveType() == MOVETYPE_WALK and band(cmd:GetButtons(), IN_JUMP) == IN_JUMP then
		if ply:IsOnGround() then
			cmd:SetButtons(bor(cmd:GetButtons(), IN_JUMP))
		else
			cmd:SetButtons(band(cmd:GetButtons(), bnot(IN_JUMP)))
		end
	end
end)

hook.Add('Move', 'CQB_Move', function(ply, move)
	if not CQB_GetConv('cqb_sv_allow_customspeed', 'bool') then return end

	wep = ply:GetActiveWeapon()

	if not (IsValid(wep) and wep.IsCQB) then return end

	speed = 400 * wep.SpeedMultiply

	move:SetMaxSpeed(speed)
	move:SetMaxClientSpeed(speed)
end)


--[[------------------------------------------------------------------------------------------------------
	CLIENT
--------------------------------------------------------------------------------------------------------]]
if CLIENT then
	language.Add('cqb_ent_grenade_bounce', 'Bouncing grenade')
	language.Add('cqb_ent_grenade', 'Grenade')

	local NewFont, Scale, SimpleText = surface.CreateFont, ScreenScale, draw.SimpleText

	local _font, _weight, _anta = 'Lycanthrope', 800, false

	local function CreateFonts()
		NewFont('CQBLarge', {
			font			= _font,
			weight			= _weight,
			size			= Scale(24),
			antialiasing	= _anta
		})

		NewFont('CQBMedium', {
			font			= _font,
			weight			= _weight,
			size			= Scale(14),
			antialiasing	= _anta
		})

		NewFont('CQBSmall', {
			font			= _font,
			weight			= _weight,
			size			= Scale(10),
			antialiasing	= _anta
		})

		NewFont('CQBMicro', {
			font			= _font,
			weight			= _weight,
			size			= Scale(7),
			antialiasing	= _anta
		})

		NewFont('CQBCross', {
			font			= Tahoma,
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
	end

	CreateFonts()

	CQB_sw, CQB_sh = ScrW(), ScrH()
	CQB_swc, CQB_shc = CQB_sw * 0.5, CQB_sh * 0.5

	CQB_ColBG = Color(0, 0, 0, 250)
	CQB_ColWH = Color(255, 255, 255)
	CQB_ColRd = Color(255, 0, 0)

	CQB_CrosshairStyles = {
		l   = { '-', '=', ':', '(', '[', '{', '|', '/', '\\', '<', '>', },
		r   = { '-', '=', ':', ')', ']', '}', '|', '\\', '/', '>', '<', },
	}

	function CQB_TextSize(text, font)
		surface.SetFont(font)

		return surface.GetTextSize(text)
	end

	function CQB_TextLimit(w, text, font)
		local _w = CQB_TextSize(text, font)

		if _w > w then
			while (true) do
				text = string.sub(text, 1, string.len(text) - 1)

				local w_ = CQB_TextSize(text .. '...', font)

				if w_ < w or string.len(text) <= 0 then break end
			end
	
			text = text .. '...'
		end
	
		return text
	end

	function CQB_format(var, max)
		local max = max or 999

		return (var > max and max) or var
	end

	function CQB_ColorFade(col1, col2, mul) -- Don't give a fuck how it works :P
		return Color(col1.r * (1 - mul) + col2.r, col1.g * mul + col2.g, col1.b * mul + col2.b, 255)
	end

	function CQB_ShadowText(text, font, x, y, align1, align2)
		SimpleText(text, font, x + 1, y + 1, CQB_ColBG, align1 or TEXT_ALIGN_CENTER, align2 or TEXT_ALIGN_CENTER)
		SimpleText(text, font, x - 1, y - 1, CQB_ColWH, align1 or TEXT_ALIGN_CENTER, align2 or TEXT_ALIGN_CENTER)
	end

	function CQB_ShadowTextColor(text, font, x, y, color, align1, align2)
		SimpleText(text, font, x + 1, y + 1, CQB_ColBG, align1 or TEXT_ALIGN_CENTER, align2 or TEXT_ALIGN_CENTER)
		SimpleText(text, font, x - 1, y - 1, color, align1 or TEXT_ALIGN_CENTER, align2 or TEXT_ALIGN_CENTER)
	end

	function CQB_CrossDot()
		local DrawColor, DrawRect = surface.SetDrawColor, surface.DrawRect

		DrawColor(CQB_ColBG)
		DrawRect(CQB_swc - 1, CQB_shc - 1, 3, 3)
		DrawColor(CQB_ColWH)
		DrawRect(CQB_swc - 2, CQB_shc - 2, 3, 3)
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

		if not wep.IsCQB then return end

		if name == 'CHudCrosshair' then
			return not CQB_GetConv('cqb_hud_crosshair', 'bool')
		end

		if HideElements[name] then
			return not CQB_GetConv('cqb_hud_enabled', 'bool')
		end
	end)

	hook.Add('OnScreenSizeChanged', 'cqb_unfuck_hud', function(w, h)
		CreateFonts()

		CQB_sw, CQB_sh = ScrW(), ScrH()
		CQB_swc, CQB_shc = CQB_sw * 0.5, CQB_sh * 0.5
	end)

	local function ClientMenu(panel)
		local _cqb_client_menu = {
			Options		= {},
			CVars		= {},
			Label		= '#Presets',
			MenuButton	= '1',
			Folder		= 'cqb_presets'
		}

		_cqb_client_menu.Options['#Default'] = {
			cqb_viewbob				= '1',
			cqb_extrafov			= '0',
			cqb_altpos				= '0',
			cqb_fancyvm				= '1',
			cqb_shells				= '1',
			cqb_shellstime			= '2',
			cqb_hud_enabled			= '1',
			cqb_hud_crosshair		= '1',
			cqb_hud_crosshairstyle	= '1',
			cqb_hud_x				= '0.25',
			cqb_hud_y				= '0.15',
		}

		_cqb_client_menu.Options['#Developer custom'] = {
			cqb_viewbob				= '1',
			cqb_extrafov			= '20',
			cqb_altpos				= '1',
			cqb_fancyvm				= '1',
			cqb_shells				= '1',
			cqb_shellstime			= '4',
			cqb_hud_enabled			= '1',
			cqb_hud_crosshair		= '1',
			cqb_hud_crosshairstyle	= '9',
			cqb_hud_x				= '0.3',
			cqb_hud_y				= '0.1',
		}

		_cqb_client_menu.CVars = {''}

		panel:ClearControls()

		panel:AddControl('ComboBox', _cqb_client_menu)

		panel:Help('Model')
		panel:CheckBox('Alt weapon pos', 'cqb_altpos')
		panel:CheckBox('Fancy viewmodel sway', 'cqb_fancyvm')
		panel:CheckBox('Enable Lua shells', 'cqb_shells')
		panel:NumSlider('Lua shells life time', 'cqb_shellstime', 2, 20)

		panel:Help('View')
		panel:CheckBox('Viewbob', 'cqb_viewbob')
		panel:NumSlider('Extra FOV', 'cqb_extrafov', -5, 20)

		panel:Help('Crosshair')
		panel:CheckBox('Enable Crosshair', 'cqb_hud_crosshair')
		panel:NumSlider('Crosshair style', 'cqb_hud_crosshairstyle', 1, 11, 0)

		panel:Help('HUD')
		panel:CheckBox('Enable HUD', 'cqb_hud_enabled')
		panel:NumSlider('HUD Horizontal modifier', 'cqb_hud_x', 0.25, 0.4)
		panel:NumSlider('HUD Vertical modifier', 'cqb_hud_y', 0.1, 0.6)
	end

	local function ServerMenu(panel)
		local _cqb_server_menu = {
			Options		= {},
			CVars		= {},
			Label		= '#Presets',
			MenuButton	= '1',
			Folder		= 'cqb_presets'
		}

		_cqb_server_menu.Options['#Default'] = {
			cqb_sv_allow_customspeed	= '1',
			cqb_sv_allow_bhop			= '1',
			cqb_sv_allow_knockback		= '1',
			cqb_sv_allow_ammolimit		= '1',
			cqb_sv_infinite_ammo		= '0',
			cqb_sv_spawner_time			= '8',
		}

		_cqb_server_menu.Options['#Developer custom'] = {
			cqb_sv_allow_customspeed	= '1',
			cqb_sv_allow_bhop			= '1',
			cqb_sv_allow_knockback		= '1',
			cqb_sv_allow_ammolimit		= '0',
			cqb_sv_infinite_ammo		= '0',
			cqb_sv_spawner_time			= '5',
		}

		_cqb_server_menu.CVars = {''}

		panel:ClearControls()

		panel:AddControl('ComboBox', _cqb_server_menu)

		panel:Help('Movement')
		panel:CheckBox('Allow custom speed', 'cqb_sv_allow_customspeed')
		panel:CheckBox('Allow auto bhop', 'cqb_sv_allow_bhop')
		panel:CheckBox('Allow weapon knockback', 'cqb_sv_allow_knockback')

		panel:Help('Ammo')
		panel:CheckBox('Allow ammo limitation', 'cqb_sv_allow_ammolimit')
		panel:CheckBox('Infinite ammo', 'cqb_sv_infinite_ammo')

		panel:Help('Entities')
		panel:NumSlider('Spawner respawn timer', 'cqb_sv_spawner_time', 1, 30)
		panel:ControlHelp('Will be applied after next pickup')
	end

	local function InfoMenu(panel)
		panel:ClearControls()

		panel:Help(CQB_ABOUT .. '\n' .. CQB_CHANGELOG)

		panel:Button('Workshop').DoClick = function()
			gui.OpenURL('https://steamcommunity.com/sharedfiles/filedetails/?id=2176251364')
		end
		panel:Button('GitHub repository').DoClick = function()
			gui.OpenURL('https://github.com/JFAexe/Gmod-Custom-Quake-Base')
		end

		panel:Help(CQB_LICENSE)
	end

	hook.Add('AddToolMenuCategories', 'CQBCustomCategory', function()
		spawnmenu.AddToolCategory('Utilities', 'CQB', '#Custom Quake Base')
	end)

	hook.Add('PopulateToolMenu', 'CQBCustomMenuSettings', function()
		spawnmenu.AddToolMenuOption('Utilities', 'CQB', 'CQBClient', '#Client', '', '', ClientMenu)
		spawnmenu.AddToolMenuOption('Utilities', 'CQB', 'CQBServer', '#Server', '', '', ServerMenu)
		spawnmenu.AddToolMenuOption('Utilities', 'CQB', 'CQBInfo', '#Info', '', '', InfoMenu)
	end)
end