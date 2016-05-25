local Utility = require("./Modules/Utility")
local WIP = {}


-- Original: http://stackoverflow.com/a/11204889/3219667
-- Even more originally from: http://lua-users.org/wiki/FileInputOutput

-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

-- tests the functions above
local file = './Other/stats.md'
local lines = lines_from(file)
-- AlertUser(lines[2])
-- AlertUser(lines[4])
n = tonumber(lines[4])   -- try to convert it to a number
if n == nil then
  error(line .. " is not a valid number")
else
  print("** n is a valid number and n*2 = "..n*2)
end

-- print all line numbers and their contents
for k,v in pairs(lines) do
  print('line['..k..']: '..v)
end

-- -- notes:
-- file = io.open('./Other/test.md', "a")
-- print(file)
-- file:write("hello", "\n")
-- file:write("hello", "\n")

-- Original: http://stackoverflow.com/a/25076090/3219667
--
--  Read the file
--
local f = io.open('./Other/test.md', "r")
local content = f:read("*a")
f:close()
--
-- Edit the string
--
content = string.gsub(content, "asdf", "Hello")
--
-- Write it out
--
local f = io.open('./Other/test.md', "w")
f:write(content)
f:close()


-- -- Read entire file at once (Alternate):
-- -- Original: http://stackoverflow.com/a/31857671/3219667
-- local open = io.open

-- local function read_file(path)
--     local file = open(path, "rb") -- r read mode and b binary mode
--     if not file then return nil end
--     local content = file:read "*a" -- *a or *all reads the whole file
--     file:close()
--     return content
-- end

-- local fileContent = read_file('./Other/stats.md');
-- AlertUser(fileContent);



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