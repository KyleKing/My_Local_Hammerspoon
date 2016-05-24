print('')
print('>> STARTED LOADING HS Profile')
print('')
hs.hotkey.setLogLevel(0)
initLog = hs.logger.new('LoadNotes')
-- initLog.setLogLevel(5) -- [0,5]

-- Confirm complete HS installation
if ( hs.ipc.cliStatus() == false ) then
	hs.alert.show('Installing hammerspoon cli tool')
	hs.ipc.cliInstall()
end
-- Use with /usr/local/bin/hs -c 'hideFiles()' or just $ hs -c 'hideFiles()'

-- Loaded files and functions:
dofile("HelloWorld.lua")
local Utility = require("Utility")
local Tiling = require("windowTiling")
dofile("Mac_Filesystem.lua")
dofile("Mac_Hardware.lua")
dofile("Mac_Peripherals.lua")
dofile("Mac_SettingsToggles.lua")
dofile("Mac_Software.lua")
dofile("Mac_Sound.lua")
local Mac = require("MacUtilities")
local WIP = require("z_In Progress")

----------------------------------------------------
-- Custom Alfred Triggers
--------------------------------------------------

local dir = 'imgs/'

function AlfredFunctions()
	local sometable = {
		{
			["func_name"]="AlertUser",
			["description"]="Custom Notification",
			["icon"]=dir..'alert.png',
			["arg"]='string'
		},
		{
			["func_name"]="manualReload",
			["description"]="Reloads Hammerspoon",
			["icon"]=dir..'reload.png'
		},
		{
			["func_name"]="hideFiles",
			["description"]="Hides dot files",
			["icon"]=dir..'hide.png'
		},
		{
			["func_name"]="showFiles",
			["description"]="Shows dot files",
			["icon"]=dir..'show.png'
		},
		{
			["func_name"]="blueutil",
			["description"]="Toggle Bluetooth on/off",
			["icon"]=dir..'bluetooth.png',
			["arg"]='string'
		},
		{
			["func_name"]="ToggleInternetSharing",
			["description"]="Toggle Internet Sharing, need off or on",
			["icon"]=dir..'internet.png',
			["arg"]='string'
		},
		{
			["func_name"]="ToggleDND",
			["description"]="Toggle Do No Disturb, need off or on",
			["icon"]=dir..'order.png',
			["arg"]='string'
		},
		{
			["func_name"]="wintile",
			["description"]="Manually Tile Windows (12 units)",
			["icon"]=dir..'tile.png',
			["arg"]='string'
		},
		{
			["func_name"]="Load_Order",
			["description"]="Reset List of Applications",
			["icon"]=dir..'order.png'
		}
	};
	print('') -- blank line between tables
	Utility.printJSON(sometable)
end
AlfredFunctions()

-- Learn LUA quickly!
-- https://learnxinyminutes.com/docs/lua/

