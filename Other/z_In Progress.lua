local Utility = require("./Modules/Utility")
local WIP = {}

--------------------------------------------------
-- WIP
--------------------------------------------------

-- -- Unsupported Spaces extension. Uses private APIs but works okay.
-- -- (http://github.com/asmagill/hammerspoon_asm.undocumented)
-- -- Make sure to download release and unarchive:
-- -- Source: https://github.com/asmagill/hs._asm.undocumented.spaces
-- spaces = require("hs._asm.undocumented.spaces")

-- hs.hotkey.bind(Utility.mash, '1', function()
-- 	-- print(spaces.debug.layout())
--   spaces.moveToSpace("1")
--   spaceChange()
-- end)
-- hs.hotkey.bind(Utility.mash, '4', function()
-- 	-- print(spaces.debug.layout())
--   spaces.moveToSpace("4")
--   spaceChange()
-- end)
-- currentSpace = tostring(spaces.currentSpace())


--------------------------------------------------

-- Simple way to keep track of all available shortcut keys:
-- http://www.hammerspoon.org/docs/hs.hotkey.html#showHotkeys

--------------------------------------------------

-- HTTP Requests? IFTTT integration?
-- http://www.hammerspoon.org/docs/hs.http.html

--------------------------------------------------


-- On connect to an external display:
-- Watch for change in resolution
	-- docs » hs.screen.watcher - http://www.hammerspoon.org/docs/hs.screen.watcher.html
-- Control screen brightness for watching a movie or other service on a larger monitor:
function WIP.ToggleBrightness()
	local brightness = hs.brightness.get()
	if Utility.isEmpty(brightness) or brightness > 20 then
		Utility.Brightness('96', 0)
	else
		Utility.Brightness('97', 30)
	end
end
hs.hotkey.bind(Utility.mash, "t", function()
	local brightness = hs.brightness.get()
	if Utility.isEmpty(brightness) or brightness > 20 then
		Utility.Brightness('96', 0)
	else
		Utility.Brightness('97', 30)
	end
end)
-- Fix boom issue, on Boom close, change audio to defaults:
	-- docs » hs.audiodevice http://www.hammerspoon.org/docs/hs.audiodevice.html

--------------------------------------------------


return WIP