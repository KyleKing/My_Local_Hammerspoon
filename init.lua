-- TODO: https://tomdebruijn.com/posts/super-fast-application-switching/
-- TODO: http://bezhermoso.github.io/2016/01/20/making-perfect-ramen-lua-os-x-automation-with-hammerspoon/

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
	os.execute('ANYBAR_PORT='..Utility.anybar3..' open -na AnyBar')
	-- -- Utility.change_file_line(Utility.file, 6, true)
else
	Utility.AnyBarUpdate( "black", true )
	-- -- Utility.change_file_line(Utility.file, 6, false)
end
-- Check Do Not Disturb Status:
local tContents = Utility.read_file(Utility.file, 'l')
if tContents[8] == 'on' then
  Utility.AnyBarUpdate( "exclamation", Utility.anybar3 )
else
  Utility.AnyBarUpdate( "black", Utility.anybar3 )
end

-- Kill AnyBar if needed:
-- -- Setup sudoers: https://github.com/Hammerspoon/hammerspoon/issues/707#issuecomment-168329103
-- os.execute("sudo kill $(ps aux | grep -i '[a]nybar' | awk '{print $2}')")

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

	--[[
     Generate additional search keys based on JSON file
		-- Download png image: https://stackoverflow.com/a/29654933/3219667
		-- Better icon api: http://icons.better-idea.org
	--]]

	function create_fn(dir, fn, filetype)
	  return dir..'favicons/'..fn..filetype
	end

	local links = Utility.readAll("./links.json")
	local links_obj = Utility.readJSON(links)
	local alfred_dir = '/Users/kyleking/Developer/My-Programming-Sketchbook/Alfred/user.workflow.D67DE9BE-47D0-4727-BF34-DFA7132EDCD1/'
	for func_name,link in pairs(links_obj) do
		-- Create filename based on JSON key
		local fn = string.gsub(func_name, "%s+", "_")
		local saved_fn = create_fn(dir, fn, '.png')
		local full_fn = alfred_dir..saved_fn
		-- Also check if the file was saved as a jpg
		local saved_fn_jpg = create_fn(dir, fn, '.jpg')
		local full_fn_jpg = alfred_dir..saved_fn_jpg
		-- Check if file is already downloaded
		if not hs.fs.attributes(full_fn) and not hs.fs.attributes(full_fn_jpg) then
			-- Request and download image:
			local url = 'https://icons.better-idea.org/icon?url='..link..'&size=15..300..500'
			local code,body,headers = hs.http.doRequest(url, 'GET')
			if body then
				-- Troubleshoot image type
				-- if not string.find(headers['Content-Type'], "png") then
				-- 	print('Error: header is not type png')
				-- 	for key,value in pairs(headers) do
				-- 		print(key..'  '..value)
				-- 	end
				-- 	saved_fn = saved_fn_jpg
				-- 	full_fn = full_fn_jpg
				-- end
				local f = assert(io.open(full_fn, 'wb'))
				f:write(body)
				f:close()
			else
				-- Set to the fallback favicon
				saved_fn = create_fn(dir, 'unknown', '.png')
				-- print(string.format('\nError: icons.better-idea.org failed to return an icon for: "%s"', url))
			end
		end
		-- Update object called by Alfred:
		table.insert(sometable, {
				["func_name"]="l "..func_name,
				["description"]="Link to: "..link,
				["icon"]=saved_fn
			})
	end

	Utility.printJSON(sometable)
end
AlfredFunctions()
