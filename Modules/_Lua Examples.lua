-- Learn LUA quickly!
-- https://learnxinyminutes.com/docs/lua/

local Utility = require("./Modules/Utility")

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

function Manipulation_of_Files()
	-- See if the file exists
	function file_exists(file)
	  local f = io.open(file, "rb")
	  if f then f:close() end
	  return f ~= nil
	end

	-- Call the above functions for line-by-line
	local file = './Other/test.md'
	local lines = Utility.read_file(file, 'l')
	local n = Utility.str_to_num( lines[4] )
	print("n is a valid number and n*2 = "..n*2)

	-- print all line numbers and their contents
	for k,v in pairs(lines) do
	  print('line['..k..']: '..v)
	end

	-- Call above functions for reading file all at once
	local content = Utility.read_file(file, 'a')
	content = string.gsub(content, "asdf", "Hello")
	-- Write to file
	local f = io.open(file, "w")
	f:write(content)
	f:close()
end
-- Manipulation_of_Files()

-- -- Note: to write a new line, use:
-- file = io.open('./Other/test.md', "a")
-- file:write("hello", "\n")

--
-- Writing to a file by changing a single line
--
function Writing_of_Files()
	local file = './Other/test.md'
	local tContents = Utility.read_file(file, 'l')
	print(tContents)

	-- Original: http://www.computercraft.info/forums2/index.php?/topic/2886-luahow-to-readwrite-certain-lines-in-files/
	--Modify a specific line
	table.remove(tContents, 8) -- will remove line 3 so we can insert the new line 3
	table.insert(tContents, 8, "New Information") -- inserts the string "New Infomation" on line 3 in the table.
	print(tContents)

	Utility.write_file(file, tContents)
end
Writing_of_Files()

--------------------------------------------------------------------------------

-- BACKUP for Mac_Sound.lua:
function streamkeys_trackInfo()
  -- AlertUser('Currently Disabled')
  -- Dysfunctional, but useful attempt
  -- -- Node isn't available to io.popen(), so these won't work
  -- local bashResult = Utility.capture("$PATH 2>&1", true)
  -- local bashResult = Utility.capture("node "..Utility.jsPath.."init.js 2>&1", false)
  -- print(bashResult)
  -- print("node "..Utility.jsPath.."init.js 2>&1")
  -- -- But the 2>&1 does capture the stdout
  -- "I'm not the biggest fan of frivolous temporary files, so I don't like this approach, though it technically works. The 2>&1 part redirects standard error (output 2) to standard output (output 1), which was already redirected to comd.txt (> is shorthand for 1>)"
  -- ` comd >comd.txt 2>&1 `
  -- Explanation from comment on: http://stackoverflow.com/a/132453/3219667


  -- Slow, working approach:
  -- os.execute("/usr/local/bin/node "..Utility.jsPath.."init.js")
  -- print("/usr/local/bin/node "..Utility.jsPath.."init.js")

  -- -- Above attempt works, but is very slow:
  local file = 'Hammerspoon/chrome_songs.applescript';
  -- -- local file = 'Hammerspoon/compiled/chrome_songs.scpt';
  -- print(Utility.scptPath..file)
  -- -- -- Run a pasted line of applescript code:
  -- -- -- local succeed, result, raw = hs.osascript.applescript('return "words"')
  -- -- local succeed, result, raw = hs.osascript._osascript('set output to "words" \n return "words"', "Applescript")
  -- -- print(succeed)
  -- -- print(result)
  -- -- print(raw)
  -- -- Run inline, long applescript files like this:
  -- local succeed, result, raw = hs.osascript._osascript([[
  -- set output to "words"
  -- return "words"
  -- ]], "Applescript")


  -- Working fetch JS output of Applescript file:
  local result = Utility.captureNEW('osascript '..Utility.scptPath..file)
  print(result)

  -- -- -- Useful for running a short JS command:
  -- -- hs.javascript("console.log('stdout');")
  -- -- -- How to run a full JS file:
  -- -- -- In this case, the file is only: `console.log('Hello World');`
  -- local result = Utility.captureNEW('/usr/local/bin/node '..Utility.jsPath.."test.js 2>&1")
  -- print(result)

  -- echo 'foo' | /usr/local/bin/node '/Users/kyleking/Developer/My-Programming-Sketchbook/JavaScript/Hammerspoon/test.js'
  -- Make sure to use "strong quoting" (' and ') otherwise special characters will be interpreted, like $, \, etc.
  -- This is especially important for later parsing in JSON because the " characters would be removed without strong quoting
  local JSparsedResult = Utility.captureNEW("echo '"..result.."' | /usr/local/bin/node "..Utility.jsPath.."parseSongInfo.js".." 2>&1")
  -- print(JSparsedResult)
  local song, artist = Utility.readJSON(JSparsedResult)
  Track_Info(song, artist)
end