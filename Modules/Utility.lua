local json = require("./Modules/dkjson")

initLog.d('')
initLog.d('>> Loading Utility Functions')

--------------------------------------------------
-- Global Utility Functions
--------------------------------------------------

local Utility = {}

Utility.mash_cmd = {"ctrl", "alt", "cmd"}
Utility.mash = {"ctrl", "alt", "cmd"}

Utility.scptPath = os.getenv("HOME")..'/Developer/My-Programming-Sketchbook/AppleScripts/'

function Utility.isEmpty(variable)
  return variable == nil or variable == ''
end

-- Useful to send data from Hammerspoon to other applications
function Utility.printJSON(table)
	local ConvertedJSON = json.encode(table)
	-- Accounts for an array:
	print('{"wrapper":'..ConvertedJSON.."}")
end

return Utility
