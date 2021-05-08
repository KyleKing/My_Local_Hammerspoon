local Utility = require("./Modules/Utility")

initLog.d('')
initLog.d('>> Loading Mac Software for:')
initLog.d('   Load Order')

--------------------------------------------------
-- Load Order Function
--------------------------------------------------

-- Control open/closed apps more easily than tweaking each app's settings
function Load_Order()
  local file = 'Hammerspoon-scpt/compiled/'
  os.execute('osascript '..Utility.scptPath..file..'load_order.scpt')
end
