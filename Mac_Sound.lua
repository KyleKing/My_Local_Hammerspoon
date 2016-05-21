local Utility = require("Utility")

print('')
print('>> Loading Mac Sound for:')
print('   Spotify')

--------------------------------------------------
-- Spotify utilities
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
    hs.alert.show('UN-muting')
  end
end

-- -- Demonstration of passing a function as an argument
-- Note: do not include the () of the function
function checkSpotify( func )
  if hs.spotify.isRunning() then
    func()
    show_track_timer = hs.timer.doAfter(1, function() spotify_track() end)
  else
    hs.alert.show('Spotify is not open')
  end
end

-- If iTunes or Chrome (Streamkeys) are open, the play pause buttons
-- can conflict. Force Spotify to play using a set of override keys
hs.hotkey.bind(Utility.mash, 'b', function ()
  checkSpotify(hs.spotify.previous)
end)
hs.hotkey.bind(Utility.mash, 'n', function ()
  checkSpotify(hs.spotify.playpause)
end)
hs.hotkey.bind(Utility.mash, 'm', function ()
  checkSpotify(hs.spotify.next)
end)
-- Custom display track/artist:
hs.hotkey.bind(Utility.mash, "j", function ()
  spotify_track()
end)
