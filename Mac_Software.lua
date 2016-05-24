local Utility = require("Utility")

initLog.d('')
initLog.d('>> Loading Mac Software for:')
initLog.d('   Load Order')

--------------------------------------------------
-- Load Order Function
--------------------------------------------------

-- Control open/closed apps more easily than tweaking each app's settings
function Load_Order()
  local file = 'Hammerspoon/compiled/load_order.scpt'
  os.execute('osascript '..Utility.scptPath..file)
end
-- Dash should always be open and is really only closed when computer first opens
-- So run load order script to open set of helpers on HS startup
local app = hs.appfinder.appFromName('Dash')
if app == nill then
  Load_Order()
end
