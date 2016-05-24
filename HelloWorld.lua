local Utility = require("Utility")

--------------------------------------------------------------------
-- Following along the Basic Guide (http://www.hammerspoon.org/go/)
--------------------------------------------------------------------

-- -- Rul Basic Hello World:
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
--   hs.alert.show("Hello World!")
-- end)

-- -- Hello World with native OSX notifications:
-- hs.hotkey.bind(Utility.mash, "W", function()
--   hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
-- end)

-- -- For testing
-- hs.hotkey.bind(Utility.mash, "t", function()
-- 	print('Testing!')
-- end)

function AlertUser(term)
  hs.alert.show(term)
  print("AlertUser: "..term)
end
-- AlertUser("it works")

----------------------------------------------------
-- Other
--------------------------------------------------

-- Force paste - good for Nylas/password entry on websites
hs.hotkey.bind({"cmd", "alt"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
-- -- Send iMessages/SMS
-- hs.messages.iMessage("4438458414", "Hey!")
-- -- hs.messages.SMS("+1234567890", "Hey, you don't have an iPhone, but you should still come for a coffee")
