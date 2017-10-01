local Utility = require("./Modules/Utility")

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
  local file = 'Hammerspoon-scpt/compiled/'
  os.execute('osascript '..Utility.scptPath..file..'load_order.scpt')
  os.execute('osascript '..Utility.scptPath..file..'load_safari_quitter.scpt')
  preventBoomAudio()
end

-- Dash should always be open (or: 'Bartender 3'):
if hs.appfinder.appFromName('Dash') == nil then
  Load_Order()
end
