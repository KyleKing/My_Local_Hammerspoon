local json = require("./Modules/dkjson")

initLog.d('')
initLog.d('>> Loading Utility Functions')

--------------------------------------------------
-- Global Utility Functions
--------------------------------------------------

local Utility = {}

-- Persistent data stored in:
Utility.file = './Other/stats.md'

Utility.mash = {"ctrl", "alt", "cmd"}
Utility.scptPath = os.getenv("HOME")..'/Developer/My-Programming-Sketchbook/AppleScripts/'
Utility.jsPath = os.getenv("HOME")..'/Developer/My-Programming-Sketchbook/JavaScript/Hammerspoon-js/'
Utility.anybar = "1738"
Utility.anybar1 = "1739"
Utility.anybar2 = "1740"
Utility.anybar3 = "1741"
-- os.execute('ANYBAR_PORT='..Utility.anybar2..' open -na AnyBar')

function Utility.isEmpty(variable)
  return variable == nil or variable == ''
end

function Utility.BattAlert(str, val)
  local message = string.format(str, val)
  hs.notify.new({title="Battery Watcher", informativeText=message}):send()
  hs.alert.show(message)
end


-- Useful to send data from Hammerspoon to other applications
function Utility.printJSON(table)
	local ConvertedJSON = json.encode(table)
	-- Accounts for an array:
	print('{"wrapper":'..ConvertedJSON.."}")
end

-- Useful to receive JSON stdin
-- See example use in ./Modules/_Lua Examples.lua
function Utility.readJSON(str)
	local obj, pos, err = json.decode(str, 1, nil)
	if err then
	  print ("Error:", err)
	  return false
	else
	 	return obj
	end
end

-- Useful for debugging:
function Utility.printTables(table)
	if type(table) == 'table' then
	  for k, v in pairs( table ) do
		  print(k.."="..v)
		end
		print('-  End Table  -')
	else
		print('This table is not a table:')
		print(table)
	end
end
function Utility.printTablesInTables(table)
	if type(table) == 'table' then
		print('')
		print('---Start Multi-Table---')
	  for k, v in pairs( table ) do
		  printTables(v)
		end
		print('---End Multi-Table---')
		print('')
	else
		print('This multi-table is not a table:')
		print(table)
	end
end

-- Applescript method of keypress events
function Utility.PressKey(key)
	hs.applescript('tell application "System Events" to key code '..key)
end

-- Work in progress, didn't work as hoped
function Utility.Brightness(key, brightness)
	hs.brightness.set(brightness)
	-- Turns out keyboard brightness is hard to set because no dedicated key code
	-- 96-f5, 97-f6, not the actual ones I wanted...
	-- http://eastmanreference.com/complete-list-of-applescript-key-codes/
	-- local count = 0
	-- repeat
	-- 	hs.timer.doAfter(count*0.25, Utility.PressKey)
	-- 	count = count + 1
	-- until count == 16
end

-- Source: http://stackoverflow.com/a/326715/3219667
function Utility.capture(cmd, raw)
	-- os.execute("/path/to/program")
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end
-- Original: http://stackoverflow.com/a/9676174/3219667
function Utility.captureNEW(cmd)
	local handle = io.popen(cmd)
  local result = handle:read("*a")
  result = string.gsub(result, '[\n\r]+', ' ')
  handle:close()
  return result
end

------------------------
-- Manipulation of Files
------------------------
-- Original: http://stackoverflow.com/a/11204889/3219667
-- Even more originally from: http://lua-users.org/wiki/FileInputOutput
-- Original: http://stackoverflow.com/a/25076090/3219667

-- See if the file exists
function Utility.file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end


function Utility.read_file(file, type)
	-- Returns an empty list/table if the file does not exist
  if not Utility.file_exists(file) then return {} end

  -- type = l ('lines')
  -- Read the file line by line and return a table of lines
  if type == 'l' then
	  lines = {}
	  for line in io.lines(file) do
	    lines[#lines + 1] = line
	  end
  	return lines

  -- type = a ('all')
  -- Alternatively, read the entire file at once
  elseif type == 'a' then
		local f = io.open('./Other/test.md', "r") -- read mode (r)
		local content = f:read("*a") -- *a or *all - reads whole file
		f:close()
		return content

	else
		error('Need type option of "a" (all) or "l" lines')
		return {}
	end
end

-- Change every line in a file
function Utility.write_file(file, content)
  -- Validate inputs
  if not Utility.file_exists(file) then return false end
  if Utility.isEmpty(content) then return false end
	-- Write to file
	local sContent = Utility.serialize(content)
	-- print(sContent)
	local f = io.open(file, "w")
	f:write(sContent)
	f:close()
	return true
end
-- Change a specific line of a file
function Utility.change_file_line(file_path, line_num, new_content)
  local tContents = Utility.read_file(file_path, 'l')
  table.remove(tContents, line_num)
  table.insert(tContents, line_num, tostring(new_content))
  -- print('Updated tContents:')
  -- Utility.printTables(tContents)
  Utility.write_file(file_path, tContents)
end

-- Serialize a Lua array with new line ("\n") delimiters
function Utility.serialize( inputTable )
	local serialString = ''
	for i,str in pairs(inputTable) do
	  serialString = serialString..str.."\n"
	end
	return serialString
end

-- Try converting a line to a number
function Utility.str_to_num(str)
	local n = tonumber(str)
	if n == nil then
	  error(line .. " is not a valid number")
	else
	  return n
	end
end

------------------------
-- AnyBar Icons
------------------------

function Utility.AnyBarUpdate( color, port )
	-- -- Applescript version:
	-- local script = 'tell application "AnyBar" to set image name to "'..color..'"'
	-- local succeed, result, raw = hs.osascript.applescript(script)
	-- -- tell application "AnyBar" to set current to get image name as Unicode text
	-- -- display notification current

	-- local color = "green"
	if type(port) == 'string' then
		-- -- Make sure anybar on that port is open:
		-- -- local portNum = Utility.str_to_num(port)
		-- -- Opens a new port, actually only call once in init.lua
		-- print('ANYBAR_PORT='..port..' open -na AnyBar')
		-- os.execute('ANYBAR_PORT='..port..' open -na AnyBar')
	else
		port = Utility.anybar
	end
	-- print(port)
	local bash_script = "/usr/local/bin/node "..Utility.jsPath..'snippetAnyBar.js "'..color..'" '..port.." 2>&1"
	local JSparsedResult = Utility.captureNEW(bash_script)
	-- print(bash_script)
end

------------------------
-- Webview Window and URL Openers
------------------------

-- FIXME: Focus the new window [ hs.window:focus() ]
function Utility.launchWebView( url, win )

	-- Notes on windowStyle:
	-- -- Appears to only be odd numbers:
	-- -- 1 - Basic Bar
	-- -- 3 - Close button
	-- -- 5 - Minimizable button
	-- -- 7 - Close/Minimize
	-- -- 9 - maximize button
	-- -- 11 - Close/Maximize buttons
	-- -- 13 - Min/Max buttons
	-- -- 15 - all three buttons
	-- Or: :windowStyle({"titled", "closable", "resizable"}) --, "fullSizeContentView"})
	-- See: https://github.com/thomasjachmann/dotfiles/blob/b1a2a4b92795c7204f3e6bd3862fec80f1edae3e/hammerspoon/.hammerspoon/apps/ticktrack.lua
	-- For more complex examples, see:
	-- https://github.com/asmagill/hammerspoon-config/blob/27a54cef941440e369754b04a9cb7e6f25e769a2/_scratch/webviewOtherURLS.lua
	-- https://github.com/asmagill/hammerspoon-config/blob/27a54cef941440e369754b04a9cb7e6f25e769a2/_scratch/dash.lua

	if type(url) == 'string' then
		-- local title = 'Learn X in Y Minutes'
		local title = 'Hammerspoon WebView Window'
		local screen = win:screen()
		local max = screen:frame()
		local margin = 100
	  local rect = hs.geometry.rect(max.x + margin, max.y + margin, max.w - 2*margin, max.h - 2*margin)
		-- local wv = hs.webview.new( rect )
		local webview = hs.webview.new( rect, {developerExtrasEnabled = true} )
		                      :url(url)
		                      :allowGestures(true)
		                      :allowNavigationGestures(true)
		                      :allowMagnificationGestures(true)
		                      :allowNewWindows(false)
		                      :allowTextEntry(true)
		                      :windowTitle(title)
		                      :windowStyle(15)
		                      :deleteOnClose(true)
		                      :show()
	  hs.application.get("Hammerspoon"):activate()
	else
		AlertUser('Error: "launchWebView" needs a string URL')
	end
end
function Utility.openURL( URL )
	initLog.d("open "..URL)
	os.execute("open "..URL)
end


function Utility.printOpenApps( name )
	-- AlertUser('Error: "printOpenApps" does nothing yet')
	-- -- See a list of all running applications:
	-- -- hs.application.runningApplications()
	-- -- https://github.com/tombruijn/dotfiles/blob/master/hammerspoon/triggers.lua
	-- function applicationRunning(name)
	  apps = hs.application.runningApplications()
	  found = false
	  for i = 1, #apps do
	    app = apps[i]
	    if app:title() == name and (#app:allWindows() > 0 or app:mainWindow()) then
		    -- print(app:title())
		    -- print(app:mainWindow())
		    -- print('\nBreak Running Apps')
		    -- print(tostring(app:title() == name))
		    -- print(tostring(#app:allWindows() > 0))
		    -- print(tostring(app:mainWindow()))
		    -- print('\nEnd Running Apps')
	      found = true
	    end
	  end

	  return found
	-- end
	-- applicationRunning('Learn X in Y Minutes')
end

local found = Utility.printOpenApps('Google Chrome')
-- print('found: '..tostring(found))

return Utility
