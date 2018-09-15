local Utility = require("./Modules/Utility")

initLog.d('')
initLog.d('>> Loading Mac Settings Toggles for:')
initLog.d('   Bluetooth')
initLog.d('   Do Not Disturb')
initLog.d('   Internet Sharing')

--------------------------------------------------
-- Settings utilities
--------------------------------------------------

-- Toggle Bluetooth
function blueutil(value)
  if value then
    os.execute('/usr/local/bin/blueutil '..value)
    local bashResult = Utility.capture('/usr/local/bin/blueutil status', false)

    -- Display result
    print(bashResult)
    AlertUser('Bluetooth '..bashResult)
    if bashResult == 'Status: on' then
    	Utility.AnyBarUpdate( "blue", Utility.anybar1 )
    else
    	Utility.AnyBarUpdate( "purple", Utility.anybar1 )
    end

  else
    hs.alert.show("Need value, either 'on' or 'off'")
  end
end

-- Toggle Do Not Disturb
function ToggleDND(setting)
  if setting then
    if setting == 'on' then
      Utility.AnyBarUpdate( "exclamation", Utility.anybar3 )
      Utility.change_file_line(Utility.file, 8, 'on')
    else
      Utility.AnyBarUpdate( "black", Utility.anybar3 )
      Utility.change_file_line(Utility.file, 8, 'off')
    end
  	-- Where setting is 'on' or 'off'
  	local file = 'Hammerspoon-scpt/compiled/ToggleDND.scpt'
  	os.execute('osascript '..Utility.scptPath..file..' '..setting)
  else
    hs.alert.show("Needs value, either 'on' or 'off'")
  end
end

-- ToggleDND("off")

-- Toggle Internet Sharing
function ToggleInternetSharing(setting)
	-- Where setting is 'on' or 'off'
	if setting then
		local file = 'Hammerspoon-scpt/compiled/InternetSharing.scpt'
		os.execute('osascript '..Utility.scptPath..file..' '..setting)
	else
    hs.alert.show("Needs value, either 'on' or 'off'")
	end
end

-- Set all Trackpad Gestures to on
function ActivateTrackpadgestures()
  -- DOES NOT WORK...
  local file = 'Hammerspoon-scpt/compiled/ActivateTrackpadGestures.scpt'
  os.execute('osascript '..Utility.scptPath..file)
end

-- Quit KYA and Sleep computer
function sleep()
  local file = 'Hammerspoon-scpt/compiled/sleep.scpt'
  os.execute('osascript '..Utility.scptPath..file)
end
