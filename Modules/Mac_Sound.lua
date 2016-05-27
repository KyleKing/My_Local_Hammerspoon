local Utility = require("./Modules/Utility")

initLog.d('')
initLog.d('>> Loading Mac Sound for:')
initLog.d('   Spotify')
initLog.d('   StreamKeys')

-- For troubleshooting:
muteLog = hs.logger.new('MuteWatcher')
-- muteLog.setLogLevel(4) -- [0,5]

-- Persistent data stored in:
local file = './Other/stats.md'

--------------------------------------------------
-- Spotify and Soundcloud utilities
--------------------------------------------------

-- Get song and artist of current playing track:
function streamkeys_trackInfo(silent)
  muteLog.df("Checking StreamKeys Track Info")
  -- Get a JSON object of the info of every open tab in Chrome:
  local file = 'Hammerspoon/chrome_songs.applescript';
  local result = Utility.captureNEW('osascript '..Utility.scptPath..file)

  -- Use that JSON as a STDIN for the following JS parser:
  -- echo 'foo' | /usr/local/bin/node '/Users/kyleking/Developer/My-Programming-Sketchbook/JavaScript/Hammerspoon/test.js'
  -- Make sure to use strong quoting with apostrophes, otherwise special characters will be interpreted, like $, \, etc.
  local JSparsedResult = Utility.captureNEW("echo '"..result.."' | /usr/local/bin/node "..Utility.jsPath.."parseSongInfo.js".." 2>&1")
  local obj = Utility.readJSON(JSparsedResult)
  -- check_if_mute(silent, '', 'mute', streamkeys_trackInfo)
  check_if_mute( silent, obj.song, obj.artist, streamkeys_trackInfo )
end
function spotify_trackInfo(silent)
  muteLog.df("Checking Spotify Track Info")
  -- hs.spotify.displayCurrentTrack()
  local song = hs.spotify.getCurrentTrack()
  local artist = hs.spotify.getCurrentArtist()
  check_if_mute( silent, song, artist, spotify_trackInfo )
end

-- Display current track name and artist
-- Then check if the song should be muted, if so, start a callback loop
function check_if_mute( silent, song, artist, callback )
  Utility.AnyBarUpdate( "red" )

  -- Check persistent settings and configure volume info:
  local tContents = Utility.read_file(file, 'l')
  local volume_prev = hs.audiodevice.defaultOutputDevice():volume() -- Get current laptop volume
  -- AlertUser(tostring(volume_prev))
  if hs.audiodevice.defaultOutputDevice():muted() or volume_prev <= 1 or Utility.isEmpty(volume_prev) then
    volume_prev = tContents[4]
  else
    Utility.change_file_line(file, 4, math.floor(volume_prev))
  end

  -- Check if computer should be muted
  muteLog.df("Mute-ifs: %s, %s, %s, or %s", Utility.isEmpty(artist), Utility.isEmpty(song), song == 'mute', artist == 'mute')
  if Utility.isEmpty(artist) or Utility.isEmpty(song) or song == 'mute' or artist == 'mute' then
    muteLog.df("Muted! Callback is: %s", callback)
    if silent == false then
      AlertUser('MUTING')
    end
    Utility.AnyBarUpdate( "green" )
    hs.audiodevice.defaultOutputDevice():setVolume(0)
    hs.audiodevice.defaultOutputDevice():setMuted(true)
    preventBoomAudio()
    mute_timer = hs.timer.doAfter(5, function() callback(true) end)
  else
    muteLog.df("volume_prev: %s - silent: %s - tContents: %s", math.floor(volume_prev), silent, tContents[2] == 'true')
    if hs.audiodevice.defaultOutputDevice():muted() or volume_prev <= 1 or Utility.isEmpty(volume_prev) then
      AlertUser('𝄆 ♩ ♪ ♫ ♬ BACK TO THE MUSIC! ♬ ♫ ♪ ♩ 𝄇')
    end
    hs.audiodevice.defaultOutputDevice():setVolume(Utility.str_to_num(volume_prev))
    hs.audiodevice.defaultOutputDevice():setMuted(false)

    -- Tell the user what they came for:
    if silent == false then
      AlertUser(song)
      AlertUser(artist)
    end
    -- Determine next step of mute callback cycle (true = no alerts)
    if tContents[2] == 'true' then
      Utility.AnyBarUpdate( "green" )
      mute_timer = hs.timer.doAfter(5, function() callback(true) end)
    end
  end
end

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
function checkIfSpotifyOpen( func, funcAlt, silent )
  if hs.spotify.isRunning() then
    func(silent)
    -- show_track_timer = hs.timer.doAfter(1, function() spotify_trackInfo() end)
  else
    funcAlt(silent)
  end
end

--
-- Control iTunes or Chrome (Streamkeys) using custom commands:
--
hs.hotkey.bind(Utility.mash, 'b', function ()
Utility.AnyBarUpdate( "blue" )
  checkIfSpotifyOpen(hs.spotify.previous, streamkeys_previous, false)
end)
hs.hotkey.bind(Utility.mash, 'n', function ()
Utility.AnyBarUpdate( "yellow" )
  checkIfSpotifyOpen(hs.spotify.playpause, streamkeys_playpause, false)
end)
hs.hotkey.bind(Utility.mash, 'm', function ()
Utility.AnyBarUpdate( "orange" )
  checkIfSpotifyOpen(hs.spotify.next, streamkeys_next, false)
end)
-- Display track/artist (and mute ads):
hs.hotkey.bind(Utility.mash, "j", function ()
  checkIfSpotifyOpen(spotify_trackInfo, streamkeys_trackInfo, false)
end)

--
-- Set Status of Ad Muter
--
-- Display track/artist (and mute ads):
hs.hotkey.bind(Utility.mash, "k", function ()
  Utility.change_file_line(file, 2, true)
  checkIfSpotifyOpen(spotify_trackInfo, streamkeys_trackInfo, false)
  AlertUser('Set Loop to True: Ad checking will ensue')
end)
-- Display track/artist (and mute ads):
hs.hotkey.bind(Utility.mash, "h", function ()
  Utility.change_file_line(file, 2, false)
  AlertUser('Set Loop to False: Ad checking should stop soon')
end)
