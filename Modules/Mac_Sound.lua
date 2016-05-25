local Utility = require("./Modules/Utility")

initLog.d('')
initLog.d('>> Loading Mac Sound for:')
initLog.d('   Spotify')
initLog.d('   StreamKeys')

--------------------------------------------------
-- Spotify and Soundcloud utilities
--------------------------------------------------

-- Get song and artist of current playing track:
function streamkeys_trackInfo()
  -- Get a JSON object of the info of every open tab in Chrome:
  local file = 'Hammerspoon/chrome_songs.applescript';
  local result = Utility.captureNEW('osascript '..Utility.scptPath..file)

  -- Use that JSON as a STDIN for the following JS parser:
  -- echo 'foo' | /usr/local/bin/node '/Users/kyleking/Developer/My-Programming-Sketchbook/JavaScript/Hammerspoon/test.js'
  -- Make sure to use strong quoting with apostrophes, otherwise special characters will be interpreted, like $, \, etc.
  local JSparsedResult = Utility.captureNEW("echo '"..result.."' | /usr/local/bin/node "..Utility.jsPath.."parseSongInfo.js".." 2>&1")
  local obj = Utility.readJSON(JSparsedResult)
  check_if_mute('', 'mute', streamkeys_trackInfo)
  -- check_if_mute(obj.song, obj.artist, streamkeys_trackInfo)
end
function spotify_trackInfo()
  -- hs.spotify.displayCurrentTrack()
  local song = hs.spotify.getCurrentTrack()
  local artist = hs.spotify.getCurrentArtist()
  check_if_mute( song, artist, spotify_trackInfo )
end

-- Display current track name and artist
-- Then check if the song should be muted, if so, start a callback loop
function check_if_mute( song, artist, callback )
  if Utility.isEmpty(artist) or Utility.isEmpty(song) or song == 'mute' or artist == 'mute' then
    -- Get previous laptop volume
    local volume_prev = hs.audiodevice.defaultOutputDevice():volume()
    -- AlertUser(tostring(volume_prev))

    -- Store persistent volume information to a file:
    local file = './Other/stats.md'
    local tContents = Utility.read_file(file, 'l')
    -- print('Raw tContents:')
    -- Utility.printTables(tContents)
    -- TODO: Check if muted too!
    if volume_prev <= 1 or Utility.isEmpty(volume_prev) then
      volume_prev = tContents[4]
    else
      table.remove(tContents, 4) -- will remove line 3 so we can insert the new line 3
      table.insert(tContents, 4, tostring(math.floor(volume_prev))) -- inserts the string "New Infomation" on line 3 in the table.
      -- print('Updated tContents:')
      -- Utility.printTables(tContents)
      Utility.write_file(file, tContents)
    end

    -- Actual mute commands:
    hs.audiodevice.defaultOutputDevice():setVolume(0)
    hs.audiodevice.defaultOutputDevice():setMuted(true)
    AlertUser('MUTING')
    preventBoomAudio()

    -- Determine next step of mute callback cycle
    if tContents[2] == true then
      mute_timer = hs.timer.doAfter(5, function() callback() end)
    else
      -- If done muting, return to regular volume
      hs.audiodevice.defaultOutputDevice():setVolume(Utility.str_to_num(volume_prev))
      hs.audiodevice.defaultOutputDevice():setMuted(false)
      AlertUser('𝄆 ♩ ♪ ♫ ♬ BACK TO THE MUSIC! ♬ ♫ ♪ ♩ 𝄇')
      AlertUser(song)
      AlertUser(artist)
    end
  else
    AlertUser(song)
    AlertUser(artist)
  end
end

-- TODO:
-- function adblocker ()
-- end

-- StreamKeys Controls
-- [Note: Spotify Controls (Currently all built-in HS functions)]
function streamkeys_previous()
  hs.eventtap.keyStroke({"ctrl"}, "j")
end
function streamkeys_playpause()
  hs.eventtap.keyStroke({"ctrl"}, "k")
end
function streamkeys_next()
  hs.eventtap.keyStroke({"ctrl"}, "l")
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

--
-- Control iTunes or Chrome (Streamkeys) using custom commands:
--
hs.hotkey.bind(Utility.mash, 'b', function ()
  checkIfSpotifyOpen(hs.spotify.previous, streamkeys_previous)
end)
hs.hotkey.bind(Utility.mash, 'n', function ()
  checkIfSpotifyOpen(hs.spotify.playpause, streamkeys_playpause)
end)
hs.hotkey.bind(Utility.mash, 'm', function ()
  checkIfSpotifyOpen(hs.spotify.next, streamkeys_next)
end)
-- Display track/artist (and mute ads):
hs.hotkey.bind(Utility.mash, "j", function ()
  checkIfSpotifyOpen(spotify_trackInfo, streamkeys_trackInfo)
end)
