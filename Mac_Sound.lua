local Utility = require("Utility")

initLog.d('')
initLog.d('>> Loading Mac Sound for:')
initLog.d('   Spotify')
initLog.d('   StreamKeys')
initLog.d('   Headphone Watcher')

--------------------------------------------------
-- Spotify and Soundcloud utilities
--------------------------------------------------

-- Display current track name and artist
function spotify_track()
  -- hs.spotify.displayCurrentTrack()
  local track = hs.spotify.getCurrentTrack()
  if Utility.isEmpty(track) then
    volume_prev = hs.audiodevice.defaultOutputDevice():volume()
    mute_ads()
  else
    hs.alert.show(track)
  end

  local artist = hs.spotify.getCurrentArtist()
  if Utility.isEmpty(artist) then
    volume_prev = hs.audiodevice.defaultOutputDevice():volume()
    mute_ads()
  else
    hs.alert.show(artist)
  end
end

-- Mute ads
function streamkeys_previous()
  hs.eventtap.keyStroke({"ctrl"}, "j")
end
function streamkeys_playpause()
  hs.eventtap.keyStroke({"ctrl"}, "k")
end
function streamkeys_next()
  hs.eventtap.keyStroke({"ctrl"}, "l")
end

-- Mute ads
function mute_ads()
  local artist = hs.spotify.getCurrentArtist()
  if Utility.isEmpty(artist) then
    -- hs.audiodevice.defaultOutputDevice():setVolume(0)
    hs.audiodevice.defaultOutputDevice():setMuted(true)
    -- hs.alert.show('MUTING')
    mute_timer = hs.timer.doAfter(5, function() mute_ads() end)
  else
    if not type(volume_prev) == 'number' then
      volume_prev = 20
    end
    -- hs.audiodevice.defaultOutputDevice():setVolume(volume_prev)
    hs.audiodevice.defaultOutputDevice():setMuted(false)
    hs.alert.show('UN-muting')
  end
end

-- -- Demonstration of passing a function as an argument
-- Note: do not include the () of the function
function checkSpotify( func, funcAlt )
  if hs.spotify.isRunning() then
    func()
    show_track_timer = hs.timer.doAfter(1, function() spotify_track() end)
  else
    funcAlt()
  end
end

-- If iTunes or Chrome (Streamkeys) are open, the play pause buttons
-- can conflict. Force Spotify to play using a set of override keys
hs.hotkey.bind(Utility.mash, 'b', function ()
  checkSpotify(hs.spotify.previous, streamkeys_previous)
end)
hs.hotkey.bind(Utility.mash, 'n', function ()
  checkSpotify(hs.spotify.playpause, streamkeys_playpause)
end)
hs.hotkey.bind(Utility.mash, 'm', function ()
  checkSpotify(hs.spotify.next, streamkeys_next)
end)
-- Custom display track/artist:
hs.hotkey.bind(Utility.mash, "j", function ()
  checkSpotify(spotify_track, streamkeysPlaypause)
end)

--------------------------------------------------
-- Headphone Connection Watcher
--------------------------------------------------

audLog = hs.logger.new('audWatcher')
-- audLog.setLogLevel(5) -- [0,5]

-- Per-device watcher to detect headphones in/out
function audioDeviceWatch(dev_uid, event_name, event_scope, event_element)
  audLog.df("AudioDeviceWatch args: %s, %s, %s, %s", dev_uid, event_name, event_scope, event_element)
  aud = hs.audiodevice.findDeviceByUID(dev_uid)
  if event_name == 'jack' then
    if aud:jackConnected() then
      hs.alert.show("Auxiliary Device Connected")
      hs.audiodevice.defaultOutputDevice():setMuted(false)
      if aud:outputVolume() >= 40 then
        hs.audiodevice.defaultOutputDevice():setVolume(30)
      end
    else
      -- hs.alert.show("Auxiliary Device Disconnected")
      hs.audiodevice.defaultOutputDevice():setMuted(true)
    end
  end
end

-- Account for all audio devices (boom is second, but also bluetooth, airplay, etc.)
for i,aud in ipairs(hs.audiodevice.allOutputDevices()) do
  audwatch = aud:watcherCallback(audioDeviceWatch)
  audwatch:watcherStart()
end
