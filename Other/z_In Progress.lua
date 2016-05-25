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

-- -- Playing around with windows:
-- -- Example Code: https://gist.github.com/asmagill/633c8515e6ace3335d31

-- local windowGoogle = hs.webview.new( {x = 50, y = 50,h = 500, w = 900} )
--                         :url('http://inbox.google.com')
--                         :allowGestures(true)
--                         :allowTextEntry(true)
--                         :windowTitle('TestWindow')
--                         :windowStyle(15)
--                         :deleteOnClose(true)
--                         :show()

-- -- Appears to only be odd numbers:
-- -- 1 - Basic Bar
-- -- 3 - Close button
-- -- 5 - Minimizable button
-- -- 7 - Close/Minimize
-- -- 9 - maximize button
-- -- 11 - Close/Maximize buttons
-- -- 13 - Min/Max buttons
-- -- 15 - all three buttons

-- -- :title('TestWindow')
-- -- hs.webview.windowMasks[] -> utility
-- hs.hotkey.bind(Utility.mash, "h", function()
-- 	windowGoogle:delete()
-- end)



--------------------------------------------------

-- Simple way to keep track of all available shortcut keys:
-- http://www.hammerspoon.org/docs/hs.hotkey.html#showHotkeys

--------------------------------------------------

-- HTTP Requests? IFTTT integration?
-- http://www.hammerspoon.org/docs/hs.http.html

--------------------------------------------------

-- Any bar icon
-- Make sure it is open, then change color by sending info to the UDP port:
-- echo -n "red" | nc -u localhost 1738
-- Should be:
-- echo -n "black" | nc -4u -w0 localhost 1738
-- But couldn't get it to work
-- Applescript:
-- ok,result = hs.applescript('tell application "AnyBar" to set image name to "question"')
-- Main link: https://github.com/tonsky/AnyBar
-- Node options:
-- Good: https://github.com/rumpl/nanybar
-- Best: https://github.com/sindresorhus/anybar

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