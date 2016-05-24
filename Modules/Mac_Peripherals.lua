local Utility = require("./Modules/Utility")
local Tiling = require("./Modules/windowTiling")

initLog.d('')
initLog.d('>> Loading Peripheral Events for:')
initLog.d('		Proscope USB Microscope')
initLog.d('		Ethernet USBWatching')
initLog.d('   Headphone Watcher')

--------------------------------------------------
-- USB Watcher Script
--------------------------------------------------

-- USB Watcher for Proscope Application
local usbWatcher = nil
function usbDeviceCallback(data)
	Utility.printTables(data)
	-- Turn on Internet sharing for Raspberry Pi development
	if (data["productName"] == "Apple USB Ethernet Adapter") then
		if (data["eventType"] == "added") then
			-- print('Start internet sharing')
			ToggleInternetSharing('on')
		elseif (data["eventType"] == "removed") then
			-- print('stop Internet sharing')
			ToggleInternetSharing('off')
		end
	end
	-- Turn on microscope software when USB camera connected
  if (data["productName"] == "Venus USB2.0 Camera") then
		if (data["eventType"] == "added") then
			hs.application.open("Proscope HR")
			-- Wait for application to open and move aside
			local win = nil
			while win == nil do
				win = hs.window('Proscope')
				if not Utility.isEmpty(win) then
					Tiling.MoveWindow ( 0, 0, 10/12, 1, win )
				end
			end
		elseif (data["eventType"] == "removed") then
			-- Quit Proscope HR App
			local app = hs.window('Proscope')
			if not Utility.isEmpty(app) then
				app = app:application()
				app:kill()
			end
		end
  end
end
usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()

--------------------------------------------------
-- Auxiliary Connection Watcher
--------------------------------------------------

audLog = hs.logger.new('audWatcher')
audLog.setLogLevel(4) -- [0,5]

-- Per-device watcher to detect headphones in/out
function audioDeviceWatch(dev_uid, event_name, event_scope, event_element)
  audLog.vf("AudioDeviceWatch args: %s, %s, %s, %s", dev_uid, event_name, event_scope, event_element)
  aud = hs.audiodevice.findDeviceByUID(dev_uid)
  if event_name == 'jack' then
    if aud:jackConnected() then
      audLog.df("args: %s, %s, %s", dev_uid, event_scope, event_element)
      hs.alert.show("Auxiliary Device Connected")
      if aud:outputVolume() >= 40 then
        hs.audiodevice.defaultOutputDevice():setVolume(30)
      end
      -- Prevent changing default output
      aud:setDefaultOutputDevice()
      hs.audiodevice.defaultOutputDevice():setMuted(false)
    else
      hs.alert.show("Auxiliary Device Disconnected")
      -- Prevent defaulting to the second audio input
      aud:setDefaultOutputDevice()
      hs.audiodevice.defaultOutputDevice():setVolume(30)
      hs.audiodevice.defaultOutputDevice():setMuted(true)
    end
  end
end

-- Account for all audio devices (boom is second, but also bluetooth, airplay, etc.)
for i,aud in ipairs(hs.audiodevice.allOutputDevices()) do
  audwatch = aud:watcherCallback(audioDeviceWatch)
  audwatch:watcherStart()
end
