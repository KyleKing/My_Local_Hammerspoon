local Utility = require("Utility")

print('')
print('>> Loading Mac Utilities for:')
print('   Battery Watcher')
print('   Spotify')
print('   Dot Files')

--------------------------------------------------
-- Macbook utilities
--------------------------------------------------

local Mac = {}

-- Quick paste second item in clipboard?
  -- Save item in clipboard and cycle through a temporary variable
  -- Essentially a second clipboard bound to a special keypress (i.e. Utility.mash + v)
  -- docs » hs.pasteboard http://www.hammerspoon.org/docs/hs.pasteboard.html



-- Basic Battery Watcher (Three additional examples are also available
-- (example code from: https://github.com/Hammerspoon/hammerspoon/issues/166#issuecomment-68320784)
pct_prev = nil

function BattAlert(str, val)
  hs.alert.show(string.format(str, val))
end

function batt_watch_low()
  pct = hs.battery.percentage()
  pct_int = math.floor(pct)
  if type(pct_int) == 'number' then
    if pct_int ~= pct_prev and not hs.battery.isCharging() and pct_int < 50 then
      BattAlert("I need NUTELLA! %d%% left!", pct_int)
      if pct_int < 30 then
        BattAlert("ABOUT TIME TO CARE ABOUT ME! %d%% left!", pct_int)
      end
      if pct_int < 20 then
        BattAlert("Prepare for war! %d%% left!", pct_int)
      end
      if pct_int < 15 then
        BattAlert("This ain't funny. %d%% left!", pct_int)
      end
      if pct_int < 10 then
        BattAlert("RED ALERT! %d%% left!", pct_int)
      end
    end
    pct_prev = pct_int
  else
    hs.alert.show("GIVE ME POWER! Running Low!")
  end
end
hs.battery.watcher.new(batt_watch_low):start()

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

-- Show or hide dot files
local DotCMD1 = 'do shell script "defaults write com.apple.finder AppleShowAllFiles '
local DotCMD2 = '; killall Finder /System/Library/CoreServices/Finder.app"'
function hideFiles()
  ok,result = hs.applescript( DotCMD1..'NO'..DotCMD2 )
  hs.alert.show("Files Hid, like blazing sun hides enemy")
end
function showFiles()
  ok,result = hs.applescript( DotCMD1..'YES'..DotCMD2 )
  hs.alert.show("Files Shown, like bright moon deceives enemy")
end

function blueutil(value)
  if value then
    os.execute('/usr/local/bin/blueutil '..value)
    local bashResult = Utility.capture('/usr/local/bin/blueutil status', false)
    hs.alert.show('Bluetooth '..bashResult)
  else
    hs.alert.show("Need value, either 'on' or 'off'")
  end
end

-- TODO: 'Mac.' isn't working for HS functions/Alfred function...

return Mac
