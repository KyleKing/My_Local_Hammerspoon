local json = require("./Modules/dkjson")

initLog.d('')
initLog.d('>> Loading Utility Functions')

--------------------------------------------------
-- Global Utility Functions
--------------------------------------------------

local Utility = {}

Utility.mash = {"ctrl", "alt", "cmd"}
Utility.scptPath = os.getenv("HOME")..'/Developer/My-Programming-Sketchbook/AppleScripts/'
Utility.jsPath = os.getenv("HOME")..'/Developer/My-Programming-Sketchbook/JavaScript/Hammerspoon/'

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

return Utility
