local Utility = require("Utility")
local Tiling = require("windowTiling")

initLog.d('')
initLog.d('>> Loading Peripheral Events for:')
initLog.d('		Proscope USB Microscope')
initLog.d('		Ethernet USBWatching')

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