print('')
print('>> STARTED LOADING HS Profile')
print('')

-- Loaded files and functions:
dofile("HelloWorld.lua")
local Utility = require("Utility")
local Tiling = require("windowTiling")
dofile("peripheral_events.lua")
local Mac = require("MacUtilities")
local WIP = require("z_In Progress")

hs.hotkey.bind({"cmd", "alt"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- Dash should always be open and is really only closed when computer first opens
-- So run load order script to open set of helpers on HS startup
function Load_Order()
	-- os.execute('osascript ~/Library/Services/load_order.scpt')
	local file = 'Hammerspoon/compiled/load_order.scpt'
	os.execute('osascript '..Utility.scptPath..file)
end

local app = hs.appfinder.appFromName('Dash')
if app == nill then
	Load_Order()
end

------- what to do with this -------
-- Automatically Recompile Applescript Files
function reloadApplescript(files)
		doReload = false
		for _,file in pairs(files) do
				if file:sub(-12) == ".applescript" then
						doReload = true
				end
		end
		if doReload then
				AlertUser('Reloaded Applescript')
				y = os.execute('cd /Users/kyleking/Developer/My-Programming-Sketchbook/AppleScripts; bash compile.sh')
				-- y = os.execute('python '..Utility.scptPath..'loader.py')
				-- y = os.execute('bash '..Utility.scptPath..'sleep.sh')
				print(y)
		end
end
hs.pathwatcher.new(Utility.scptPath, reloadApplescript):start()
------- what to do with this -------

----------------------------------------------------
-- Custom Alfred Triggers
--------------------------------------------------
-- Configure:
if ( hs.ipc.cliStatus() == false ) then
	hs.alert.show('Installing hammerspoon cli tool')
	hs.ipc.cliInstall()
end
-- Call by typing /usr/local/bin/hs -c 'hideFiles()' or just $ hs -c 'hideFiles()'

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
	Utility.printJSON(sometable)
end
AlfredFunctions()

-- Learn LUA quickly!
-- https://learnxinyminutes.com/docs/lua/

