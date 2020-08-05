--[[------------------------------------------------------------------------------------------------------
	Edit this
--------------------------------------------------------------------------------------------------------]]
local name				= 'CQB Base'
local required_version	= 2.1


--[[------------------------------------------------------------------------------------------------------
	Do not touch
--------------------------------------------------------------------------------------------------------]]
local text				= 'Requires CQB version ' .. required_version .. ' or higher\nYou need to download it from Workshop/Github'
local hookname			= '_' .. string.Replace(name, ' ', '_') .. '_CheckDamnBase'

local function _RemoveCheck()
	timer.Simple(0, function() hook.Remove('InitPostEntity', hookname) end)
end

local function _CheckDamnBase()
	if CQB_VER and CQB_VER >= required_version then
		if not CLIENT then
			MsgC(Color(50, 255, 50), name, 'base check is fine', '\n')
		end

		return _RemoveCheck()
	end

	if CLIENT then
		local function workshop()
			gui.OpenURL('https://steamcommunity.com/sharedfiles/filedetails/?id=2176251364')
		end

		local function github()
			gui.OpenURL('https://github.com/JFAexe/Gmod-Custom-Quake-Base')
		end

		Derma_Query(text, name .. ' notify' , 'Workshop', workshop, 'Github', github, 'Close', nil)
	else
		MsgC(Color(255, 50, 50), name .. ' notify', text, '\n')
	end

	_RemoveCheck()
end

-- Uncomment to run check
-- hook.Add('InitPostEntity', hookname, _CheckDamnBase)