-- Learn LUA quickly!
-- https://learnxinyminutes.com/docs/lua/

--------------------------------------------------------------------------------

-- -- Demonstration of passing a function as an argument
-- -- Note do not include the () of the function
-- function test1( func )
--   func()
-- end
-- test1(spotify_track)

-- function test( func, arg )
--   func( arg )
-- end
-- test(AlertUser, "WORKS!")

--------------------------------------------------------------------------------

-- Test utility function to work with JSON
-- local str = [[
-- {
--   "numbers": [ 2, 3, -20.23e+2, -4 ],
--   "currency": "\u20AC"
-- }
-- ]]
-- local str = [[
-- {
-- 	"song":"Bang Harder (ft. Shyheim & Ill By Instinct) in Lyrical Abrasion",
-- 	"artist":"Trails"
-- }
-- ]]

local obj = Utility.readJSON(str)

for i = 1,#obj.numbers do
  print (i, obj.numbers[i])
end
print ("currency", obj.currency)
-- Or --
print ("song", obj.song)
print ("artist", obj.artist)

--------------------------------------------------------------------------------

------------------------
-- Manipulation of Files
------------------------
-- Original: http://stackoverflow.com/a/11204889/3219667
-- Even more originally from: http://lua-users.org/wiki/FileInputOutput
-- Original: http://stackoverflow.com/a/25076090/3219667

-- See if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function read_file(file, type)
	-- Returns an empty list/table if the file does not exist
  if not file_exists(file) then return {} end

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
  else if type == 'a' then
		local f = io.open('./Other/test.md', "r") -- read mode (r)
		local content = f:read("*a") -- *a or *all - reads whole file
		f:close()
		return content

	else
		error('Need type option of "a" (all) or "l" lines')
		return {}
	end
end

-- Try converting a line to a number
function str_to_num(str)
	local n = tonumber(str)
	if n == nil then
	  error(line .. " is not a valid number")
	else
	  return n
	end
end

-- Call the above functions for line-by-line
local file = './Other/test.md'
local lines = read_file(file, 'l')
local n = str_to_num( lines[4] )
print("n is a valid number and n*2 = "..n*2)

-- print all line numbers and their contents
for k,v in pairs(lines) do
  print('line['..k..']: '..v)
end

-- Call above functions for reading file all at once
local content = read_file(file, 'a')
content = string.gsub(content, "asdf", "Hello")
-- Write to file
local f = io.open(file, "w")
f:write(content)
f:close()

-- -- Note: to write a new line, use:
-- file = io.open('./Other/test.md', "a")
-- file:write("hello", "\n")

--------------------------------------------------------------------------------

