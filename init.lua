-- TODO: https://tomdebruijn.com/posts/super-fast-application-switching/
-- TODO: http://bezhermoso.github.io/2016/01/20/making-perfect-ramen-lua-os-x-automation-with-hammerspoon/

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
dofile("./Modules/HelloWorld.lua")
local Utility = require("./Modules/Utility")
local Tiling = require("./Modules/windowTiling")
dofile("./Modules/Mac_Browsers.lua")
dofile("./Modules/Mac_Filesystem.lua")
dofile("./Modules/Mac_Hardware.lua")
dofile("./Modules/Mac_Peripherals.lua")
dofile("./Modules/Mac_SettingsToggles.lua")
dofile("./Modules/Mac_Software.lua")
dofile("./Modules/Mac_Sound.lua")
local Mac = require("./Modules/MacUtilities")
local WIP = require("./Other/z_In Progress")

----------------------------------------------------
-- Any Bar
----------------------------------------------------

-- -- Get current color of AnyBar
-- -- Wanted to see if open, but opens up the app anyway
-- local success, color, raw = hs.applescript([[
-- 	tell application "AnyBar" to set current to get image name as Unicode text
-- 	return current
-- ]])

-- -- Previous write to file approach:
-- -- local tContents = Utility.read_file(Utility.file, 'l')
-- -- if tContents[6] == 'false' then

-- Open AnyBar, by checking for active processes:
local result = Utility.captureNEW("ps aux | grep -i '[a]nybar'")
if result == '' then
	os.execute('open /Users/kyleking/Applications/AnyBar.app')
	os.execute('ANYBAR_PORT='..Utility.anybar1..' open -na AnyBar')
	os.execute('ANYBAR_PORT='..Utility.anybar2..' open -na AnyBar')
	-- -- Utility.change_file_line(Utility.file, 6, true)
else
	Utility.AnyBarUpdate( "black", true )
	-- -- Utility.change_file_line(Utility.file, 6, false)
end
-- Kill AnyBar if needed:
-- -- Setup sudoers: https://github.com/Hammerspoon/hammerspoon/issues/707#issuecomment-168329103
-- os.execute("sudo kill $(ps aux | grep -i '[a]nybar' | awk '{print $2}')")

----------------------------------------------------
-- Custom Alfred Triggers
----------------------------------------------------

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
			["func_name"]="learnXinY",
			["description"]="Shortcut to lXinY, type language",
			["icon"]=dir..'internet.png',
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
