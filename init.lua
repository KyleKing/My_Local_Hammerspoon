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
-- local Tiling = require("./Modules/windowTiling")  -- See Hookshot/Rectangle
dofile("./Modules/Mac_Filesystem.lua")
dofile("./Modules/Mac_Software.lua")

----------------------------------------------------
-- Keyboard Hacks
----------------------------------------------------

-- Make End consistent btwn Win & Mac. Go to end of line
hs.hotkey.bind(Utility.mash_cmd, "End", function()
    hs.eventtap.keyStroke(Utility.mash_cmd, "Right")
end)
-- Make Home consistent. Go to start of line
hs.hotkey.bind(Utility.mash_cmd, "Home", function()
    hs.eventtap.keyStroke(Utility.mash_cmd, "Left")
end)

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
			["func_name"]="wintile",
			["description"]="[l#,r#,t#,b#] Tile Window (12 units - space delim)",
			["icon"]=dir..'tile.png',
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
