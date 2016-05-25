local Utility = require("./Modules/Utility")

initLog.d('')
initLog.d('>> Loading Mac Sound for:')
initLog.d('   Spotify')
initLog.d('   StreamKeys')

--------------------------------------------------
-- Spotify and Soundcloud utilities
--------------------------------------------------

-- Display current track name and artist
function spotify_trackInfo()
  -- hs.spotify.displayCurrentTrack()
  local song = hs.spotify.getCurrentTrack()
  local artist = hs.spotify.getCurrentArtist()
  if Utility.isEmpty(song) or Utility.isEmpty(artist) then
    volume_prev = hs.audiodevice.defaultOutputDevice():volume()
    mute_ads()
  else
    AlertUser(song)
    AlertUser(artist)
  end
end

-- StreamKeys Controls
function streamkeys_previous()
  hs.eventtap.keyStroke({"ctrl"}, "j")
end
function streamkeys_playpause()
  hs.eventtap.keyStroke({"ctrl"}, "k")
end
function streamkeys_next()
  hs.eventtap.keyStroke({"ctrl"}, "l")
end
function streamkeys_trackInfo()
  AlertUser('Currently Disabled')
  -- -- Dysfunctional, but useful attempt
  -- -- -- Node isn't available to io.popen(), so these won't work
  -- -- local bashResult = Utility.capture("$PATH 2>&1", true)
  -- -- local bashResult = Utility.capture("node "..Utility.jsPath.."init.js 2>&1", false)
  -- -- print(bashResult)
  -- -- print("node "..Utility.jsPath.."init.js 2>&1")
  -- -- -- But the 2>&1 does capture the stdout
  -- -- "I'm not the biggest fan of frivolous temporary files, so I don't like this approach, though it technically works. The 2>&1 part redirects standard error (output 2) to standard output (output 1), which was already redirected to comd.txt (> is shorthand for 1>)"
  -- -- ` comd >comd.txt 2>&1 `
  -- -- Explanation from comment on: http://stackoverflow.com/a/132453/3219667


  -- -- Slow, working approach:
  -- -- os.execute("/usr/local/bin/node "..Utility.jsPath.."init.js")
  -- -- print("/usr/local/bin/node "..Utility.jsPath.."init.js")

  -- -- -- Above attempt works, but is very slow:
  -- local file = 'Hammerspoon/chrome_songs.applescript';
  -- -- -- local file = 'Hammerspoon/compiled/chrome_songs.scpt';
  -- -- print(Utility.scptPath..file)
  -- -- -- -- Run a pasted line of applescript code:
  -- -- -- -- local succeed, result, raw = hs.osascript.applescript('return "words"')
  -- -- -- local succeed, result, raw = hs.osascript._osascript('set output to "words" \n return "words"', "Applescript")
  -- -- -- print(succeed)
  -- -- -- print(result)
  -- -- -- print(raw)
  -- -- -- Run inline, long applescript files like this:
  -- -- local succeed, result, raw = hs.osascript._osascript([[
  -- -- set output to "words"
  -- -- return "words"
  -- -- ]], "Applescript")


  -- -- Working fetch JS output of Applescript file:
  -- local result = Utility.captureNEW('osascript '..Utility.scptPath..file)
  -- print(result)

  -- -- -- -- Useful for running a short JS command:
  -- -- -- hs.javascript("console.log('stdout');")
  -- -- -- -- How to run a full JS file:
  -- -- -- -- In this case, the file is only: `console.log('Hello World');`
  -- -- local result = Utility.captureNEW('/usr/local/bin/node '..Utility.jsPath.."test.js 2>&1")
  -- -- print(result)

  -- -- echo 'foo' | /usr/local/bin/node '/Users/kyleking/Developer/My-Programming-Sketchbook/JavaScript/Hammerspoon/test.js'
  -- -- Make sure to use "strong quoting" (' and ') otherwise special characters will be interpreted, like $, \, etc.
  -- -- This is especially important for later parsing in JSON because the " characters would be removed without strong quoting
  -- local JSparsedResult = Utility.captureNEW("echo '"..result.."' | /usr/local/bin/node "..Utility.jsPath.."parseSongInfo.js".." 2>&1")
  -- -- print(JSparsedResult)
  -- local song, artist = Utility.readJSON(JSparsedResult)
  -- Track_Info(song, artist)
end
function Track_Info(song, artist)
  if Utility.isEmpty(song) or artist == 'mute' then
    hs.audiodevice.defaultOutputDevice():setVolume(0)
    hs.audiodevice.defaultOutputDevice():setMuted(true)
    AlertUser('MUTING')
  else
    AlertUser(song)
    AlertUser(artist)
  end
end
-- streamkeys_trackInfo()

-- Mute ads
function mute_ads()
  local artist = hs.spotify.getCurrentArtist()
  if Utility.isEmpty(artist) then
    hs.audiodevice.defaultOutputDevice():setVolume(0)
    hs.audiodevice.defaultOutputDevice():setMuted(true)
    -- AlertUser('MUTING')
    mute_timer = hs.timer.doAfter(5, function() mute_ads() end)
  else
    if not type(volume_prev) == 'number' then
      volume_prev = 20
    end
    hs.audiodevice.defaultOutputDevice():setVolume(volume_prev)
    hs.audiodevice.defaultOutputDevice():setMuted(false)
    AlertUser('𝄆 ♩ ♪ ♫ ♬ BACK TO THE MUSIC! ♬ ♫ ♪ ♩ 𝄇')
  end
  preventBoomAudio()
end

-- -- Demonstration of passing a function as an argument
-- Note: do not include the () of the function
function checkIfSpotifyOpen( func, funcAlt )
  if hs.spotify.isRunning() then
    func()
    show_track_timer = hs.timer.doAfter(1, function() spotify_trackInfo() end)
  else
    funcAlt()
  end
end

-- If iTunes or Chrome (Streamkeys) are open, the play pause buttons
-- can conflict. Force Spotify to play using a set of override keys
hs.hotkey.bind(Utility.mash, 'b', function ()
  checkIfSpotifyOpen(hs.spotify.previous, streamkeys_previous)
end)
hs.hotkey.bind(Utility.mash, 'n', function ()
  checkIfSpotifyOpen(hs.spotify.playpause, streamkeys_playpause)
end)
hs.hotkey.bind(Utility.mash, 'm', function ()
  checkIfSpotifyOpen(hs.spotify.next, streamkeys_next)
end)
-- Custom display track/artist:
hs.hotkey.bind(Utility.mash, "j", function ()
  checkIfSpotifyOpen(spotify_trackInfo, streamkeys_trackInfo)
end)
