print('')
print('>> STARTED LOADING HS Profile')
print('')
hs.hotkey.setLogLevel(0)
initLog = hs.logger.new('LoadNotes')
-- initLog.setLogLevel(5) -- [0,5]

hs.application.enableSpotlightForNameSearches(true)

-- Confirm complete HS installation
if ( hs.ipc.cliStatus() == false ) then
	hs.alert.show('Installing hammerspoon cli tool')
	hs.ipc.cliInstall()
end
-- Use with /usr/local/bin/hs -c 'hideFiles()' or just $ hs -c 'hideFiles()'

-- Loaded files and functions:
local Utility = require("./Modules/Utility")
local Tiling = require("./Modules/windowTiling")
dofile("./Modules/Mac_Filesystem.lua")
dofile("./Modules/Mac_Software.lua")

----------------------------------------------------
-- Custom Alfred Triggers
----------------------------------------------------

local dir = 'imgs/'

function link(url)
	print(string.format('open "%s"', url))
	os.execute(string.format('open "%s"', url))
end

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
			["description"]="Refresh Hammerspoon",
			["icon"]=dir..'reload.png'
		},
		{
			["func_name"]="hideFiles",
			["description"]="Hides all dot files",
			["icon"]=dir..'hide.png'
		},
		{
			["func_name"]="showFiles",
			["description"]="Shows all dot files",
			["icon"]=dir..'show.png'
		},
		{
			["func_name"]="blueutil",
			["description"]="[on/off] Set Bluetooth",
			["icon"]=dir..'bluetooth.png',
			["arg"]='string'
		},
		{
			["func_name"]="sleep",
			["description"]="Quit KYA and Sleep",
			["icon"]=dir..'sleep.png'
		},
		{
			["func_name"]="ToggleInternetSharing",
			["description"]="[on/off] Set Internet Sharing",
			["icon"]=dir..'internet-white.png',
			["arg"]='string'
		},
		{
			["func_name"]="ToggleDND",
			["description"]="[on/off] Set Do No Disturb",
			["icon"]=dir..'order.png',
			["arg"]='string'
		},
		{
			["func_name"]="wintile",
			["description"]="[l#,r#,t#,b#] Tile Window (12 units - space delim)",
			["icon"]=dir..'tile.png',
			["arg"]='string'
		},
		{
			["func_name"]="learnXinY",
			["description"]="[<language>] Open mini browser to XinY",
			["icon"]=dir..'internet-alt.png',
			["arg"]='string'
		},
		{
			["func_name"]="Load_Order",
			["description"]="Reset List of Open Applications",
			["icon"]=dir..'order.png'
		}
	};

	Utility.printJSON(sometable)
end
AlfredFunctions()
