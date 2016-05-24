local Utility = require("Utility")

initLog.d('')
initLog.d('>> Loading Mac Software for:')
initLog.d('   Load Order')

--------------------------------------------------
-- Load Order Function
--------------------------------------------------

function preventBoomAudio()
  -- Account for all audio devices (boom is second, but also bluetooth, airplay, etc.)
    -- Prevent boom from being primary output and essentially muting device
  if hs.appfinder.appFromName('Boom') == nil then
    for i,aud in ipairs(hs.audiodevice.allOutputDevices()) do
      if i == 1 then
        aud:setDefaultOutputDevice()
      end
    end
  end
end

-- Control open/closed apps more easily than tweaking each app's settings
function Load_Order()
  local file = 'Hammerspoon/compiled/load_order.scpt'
  os.execute('osascript '..Utility.scptPath..file)
  preventBoomAudio()
end
-- Dash should always be open and is really only closed when computer first opens
-- So run load order script to open set of helpers on HS startup
if hs.appfinder.appFromName('Dash') == nill then
  Load_Order()
end
