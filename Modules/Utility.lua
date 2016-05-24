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

-- Useful to send data from Hammerspoon to other applications
function Utility.printJSON(table)
	local ConvertedJSON = json.encode(table)
	-- Accounts for an array:
	print('{"wrapper":'..ConvertedJSON.."}")
end

-- Useful to receive input
function Utility.readJSON(str)
	local test_str = [[
	{
	  "numbers": [ 2, 3, -20.23e+2, -4 ],
	  "currency": "\u20AC"
	}
	]]
	local obj, pos, err = json.decode (test_str, 1, nil)
	if err then
	  print ("Error:", err)
	else
	  print ("currency", obj.currency)
	  for i = 1,#obj.numbers do
	    print (i, obj.numbers[i])
	  end
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

function Utility.PressKey(key)
	hs.applescript('tell application "System Events" to key code '..key)
end

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
-- Source: http://stackoverflow.com/a/9676174/3219667
function Utility.captureNEW(cmd)
	local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()
  return result
end

return Utility