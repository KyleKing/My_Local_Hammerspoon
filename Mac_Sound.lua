local Utility = require("Utility")

initLog.d('')
initLog.d('>> Loading Mac Sound for:')
initLog.d('   Spotify')
initLog.d('   StreamKeys')

--------------------------------------------------
-- Spotify and Soundcloud utilities
--------------------------------------------------

-- LINK: https://github.com/Hammerspoon/hammerspoon/issues/529#issuecomment-136679247
-- Yes, that must be either an app with no visible windows, or a hidden app (cmd-h).
-- The snippet below will let you know (by calling callbackNoWindows) when AppName has no more visible windows for whatever reason (app hidden, all windows closed, all windows minimised, app closed):
-- function appRunning(windows) end
-- function appNotRunning()
--   if hs.application.find('Boom') then print('Boom is still running')
--   else print('Boom has been closed') end
-- end
-- hs.window.filter.new('Boom'):notify(appRunning,appNotRunning)

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
    hs.audiodevice.defaultOutputDevice():setVolume(0)
    hs.audiodevice.defaultOutputDevice():setMuted(true)
    -- hs.alert.show('MUTING')
    mute_timer = hs.timer.doAfter(5, function() mute_ads() end)
  else
    if not type(volume_prev) == 'number' then
      volume_prev = 20
    end
    hs.audiodevice.defaultOutputDevice():setVolume(volume_prev)
    hs.audiodevice.defaultOutputDevice():setMuted(false)
    hs.alert.show('𝄆 ♩ ♪ ♫ ♬ BACK TO THE MUSIC! ♬ ♫ ♪ ♩ 𝄇')
  end
  preventBoomAudio()
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
