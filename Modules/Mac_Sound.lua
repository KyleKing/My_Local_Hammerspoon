local Utility = require("./Modules/Utility")

initLog.d('')
initLog.d('>> Loading Mac Sound for:')
initLog.d('   Spotify')
initLog.d('   StreamKeys')

-- For troubleshooting:
muteLog = hs.logger.new('MuteWatcher')
-- muteLog.setLogLevel(4) -- [0,5]

--------------------------------------------------
-- Spotify and Soundcloud utilities
--------------------------------------------------

--------------------------------------------------
-- Get Song and Artist
--------------------------------------------------

-- Get song and artist of current playing track:
function streamkeys_trackInfo(silent, startWatcher)
  if Utility.printOpenApps('Google Chrome') then
    muteLog.df("Checking StreamKeys Track Info")
    -- Get a JSON object of the info of every open tab in Chrome:
    local file = 'Hammerspoon-scpt/chrome_songs.applescript';
    local result = Utility.captureNEW('osascript '..Utility.scptPath..file)

    -- Use that JSON as a STDIN for the following JS parser:
    -- echo 'foo' | /usr/local/bin/node '/Users/kyleking/Developer/My-Programming-Sketchbook/JavaScript/Hammerspoon/test.js'
    -- Make sure to use strong quoting with apostrophes, otherwise special characters will be interpreted, like $, \, etc.
    local JSparsedResult = Utility.captureNEW("echo '"..result.."' | /usr/local/bin/node "..Utility.jsPath.."parseSongInfo.js".." 2>&1")
    local obj = Utility.readJSON(JSparsedResult)
    if not Utility.isEmpty(obj) and type(obj) == 'table' then
      if startWatcher == true then
        check_if_mute( silent, obj.song, obj.artist, streamkeys_trackInfo )
      else
        displaySongInfo(obj.song, obj.artist, silent)
      end
    else
      AlertUser('Empty obj for Soundcloud')
    end
  else
    print('Chrome is closed, doing nothing.')
  end
end
function spotify_trackInfo(silent, startWatcher)
  if hs.spotify.isRunning() then
    muteLog.df("Checking Spotify Track Info")
    -- hs.spotify.displayCurrentTrack()
    local song = hs.spotify.getCurrentTrack()
    local artist = hs.spotify.getCurrentArtist()
    if artist == "Various Artists" then
      artist = 'mute'
    end
    if startWatcher == nil then
      AlertUser("STARTWATCHER IS NIL!")
    elseif startWatcher == true then
      check_if_mute( silent, song, artist, spotify_trackInfo )
    else
      displaySongInfo(song, artist, silent)
    end
  else
    print('Spotify is closed, doing nothing.')
  end
end

--------------------------------------------------
-- Control Volume Settings
--------------------------------------------------

function mute_sound( silent, song, artist, callback )
  muteLog.df("Muted! Callback is: %s", callback)
  if silent == false then
    AlertUser('MUTING')
  end
  Utility.AnyBarUpdate( "yellow", Utility.anybar2 )
  Utility.AnyBarUpdate( "green", true )
  hs.audiodevice.defaultOutputDevice():setVolume(0)
  hs.audiodevice.defaultOutputDevice():setMuted(true)
  preventBoomAudio()
  hs.timer.doAt(Utility.incSeconds(10), function() callback(true, true) end)
end
function unmute_sound( silent, song, artist, callback, tContents, volume_prev )
  muteLog.df("Mute-ifs: %s, %s, %s, or %s", Utility.isEmpty(artist), Utility.isEmpty(song), song == 'mute', artist == 'mute')
  if hs.audiodevice.defaultOutputDevice():muted() or volume_prev <= 1 or Utility.isEmpty(volume_prev) then
    AlertUser('𝄆 ♩ ♪ ♫ ♬ BACK TO THE MUSIC! ♬ ♫ ♪ ♩ 𝄇')
  end
  hs.audiodevice.defaultOutputDevice():setVolume(Utility.str_to_num(volume_prev))
  hs.audiodevice.defaultOutputDevice():setMuted(false)

  displaySongInfo(song, artist, silent)

  -- Determine next step of mute callback cycle (true = no alerts)
  Utility.AnyBarUpdate( "cyan", Utility.anybar2 )
  if tContents[2] == 'true' then
    Utility.AnyBarUpdate( "green", true )
    hs.timer.doAt(Utility.incSeconds(10), function() callback(true, true) end)
  else
    -- Set Everything to Red:
    Utility.AnyBarUpdate( "red", true )
    Utility.AnyBarUpdate( "red", Utility.anybar2 )
  end
end

function displaySongInfo(song, artist, silent)
  -- Make sure the right info was retrieved
  if Utility.isEmpty(song) then
    song = 'unknown'
  end
  if Utility.isEmpty(artist) then
    artist = 'unknown'
  end

  -- Tell the user what they came for:
  if silent == false then
    AlertUser(song)
    AlertUser(artist)
  else
    print(song)
    print(artist)
  end
end

--------------------------------------------------
-- Mute Logic
--------------------------------------------------

-- Display current track name and artist
-- Then check if the song should be muted, if so, start a callback loop
function check_if_mute( silent, song, artist, callback )
  Utility.AnyBarUpdate( "red", true )

  -- Check persistent settings and configure volume info:
  local tContents = Utility.read_file(Utility.file, 'l')
  local volume_prev = hs.audiodevice.defaultOutputDevice():volume() -- Get current laptop volume
  -- AlertUser(tostring(volume_prev))
  if hs.audiodevice.defaultOutputDevice():muted() or volume_prev <= 1 or Utility.isEmpty(volume_prev) then
    volume_prev = tContents[4]
  else
    muteLog.df("volume_prev: %s - silent: %s - tContents: %s", math.floor(volume_prev), silent, tContents[2] == 'true')
    Utility.change_file_line(Utility.file, 4, math.floor(volume_prev))
  end

  -- Check if computer should be muted
  if Utility.isEmpty(artist) or Utility.isEmpty(song) or song == 'mute' or artist == 'mute' then
    mute_sound( silent, song, artist, callback )
  else
    unmute_sound( silent, song, artist, callback, tContents, volume_prev )
  end
end

--------------------------------------------------
-- Shortcut Keys
--------------------------------------------------

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
function checkIfSpotifyOpen( func, funcAlt, silent, startWatcher )
  if hs.spotify.isRunning() then
    func(silent, startWatcher)
    -- show_track_timer = hs.timer.doAfter(1, function() spotify_trackInfo() end)
    -- show_track_timer = hs.timer.doAt(Utility.incSeconds(1), function() spotify_trackInfo() end)
  elseif Utility.printOpenApps('Google Chrome') then
    funcAlt(silent, startWatcher)
  else
    print('Nothing is open, doing nothing.')
  end
end

--
-- Control iTunes or Chrome (Streamkeys) using custom commands:
--
hs.hotkey.bind(Utility.mash, 'b', function ()
  Utility.AnyBarUpdate( "blue", true )
  checkIfSpotifyOpen(hs.spotify.previous, streamkeys_previous)
end)
hs.hotkey.bind(Utility.mash, 'n', function ()
  Utility.AnyBarUpdate( "yellow", true )
  checkIfSpotifyOpen(hs.spotify.playpause, streamkeys_playpause)
end)
hs.hotkey.bind(Utility.mash, 'm', function ()
  Utility.AnyBarUpdate( "orange", true )
  checkIfSpotifyOpen(hs.spotify.next, streamkeys_next)
end)
-- Display track/artist (and mute ads):
hs.hotkey.bind(Utility.mash, "j", function ()
  checkIfSpotifyOpen(spotify_trackInfo, streamkeys_trackInfo, false, false)
end)

--
-- Set Status of Ad Muter
--
-- Display track/artist (and mute ads):
hs.hotkey.bind(Utility.mash, "k", function ()
  Utility.change_file_line(Utility.file, 2, true)
  checkIfSpotifyOpen(spotify_trackInfo, streamkeys_trackInfo, false, true)
  AlertUser('Set Loop to True: Ad checking will ensue')
end)
-- Display track/artist (and mute ads):
hs.hotkey.bind(Utility.mash, "h", function ()
  Utility.change_file_line(Utility.file, 2, false)
  AlertUser('Set Loop to False: Ad checking should stop soon')
  -- Force reload to allow watchers to function once again
  hs.reload()
end)
