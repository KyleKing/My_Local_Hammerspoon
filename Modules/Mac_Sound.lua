local Utility = require("./Modules/Utility")

initLog.d('')
initLog.d('>> Loading Mac Sound for:')
initLog.d('   Spotify')
initLog.d('   StreamKeys')

--------------------------------------------------
-- Spotify and Soundcloud utilities
--------------------------------------------------

-- Display current track name and artist
function streamkeys_trackInfo()
  local file = 'Hammerspoon/chrome_songs.applescript';

  -- Working fetch JS output of Applescript file:
  local result = Utility.captureNEW('osascript '..Utility.scptPath..file)

  -- echo 'foo' | /usr/local/bin/node '/Users/kyleking/Developer/My-Programming-Sketchbook/JavaScript/Hammerspoon/test.js'
  -- Make sure to use "strong quoting" (' and ') otherwise special characters will be interpreted, like $, \, etc.
  -- This is especially important for later parsing in JSON because the " characters would be removed without strong quoting
  local JSparsedResult = Utility.captureNEW("echo '"..result.."' | /usr/local/bin/node "..Utility.jsPath.."parseSongInfo.js".." 2>&1")
  local obj = Utility.readJSON(JSparsedResult)
  Track_Info(obj.song, obj.artist)
end
function Track_Info(song, artist)
  if Utility.isEmpty(artist) or Utility.isEmpty(song) or artist == 'mute' then
    hs.audiodevice.defaultOutputDevice():setVolume(0)
    hs.audiodevice.defaultOutputDevice():setMuted(true)
    AlertUser('MUTING')
  else
    AlertUser(song)
    AlertUser(artist)
  end
end

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
