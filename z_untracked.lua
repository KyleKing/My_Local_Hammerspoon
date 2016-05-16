
--------------------------------------------------
-- Things no longer pursuing
--------------------------------------------------


-- -- Create a Caffeine clone (i.e. interactive menu bar icon)
-- Finish Keeping You Awake Replacement
-- http://www.hammerspoon.org/docs/hs.caffeinate.html
-- local caffeine = hs.menubar.new()
-- function setCaffeineDisplay(state)
--     if state then
--         caffeine:setTitle("AWAKE")
--         -- caffeine:setIcon()
--     else
--         caffeine:setTitle("SLEEPY")
--         -- caffeine:setIcon()
--     end
-- end
-- function caffeineClicked()
--     setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
-- end
-- if caffeine then
--     caffeine:setClickCallback(caffeineClicked)
--     setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
-- end


--------------------------------------------------

--------------------------------------------------
-- Time Tracking
--------------------------------------------------

-- hs.uielement.focusedElement()

-- hs.hotkey.bind(Utility.mash, "p", function()
-- 	local kyle = hs.uielement.focusedElement()
-- 	hs.alert.show(kyle)
-- end)


-- Fails?
-- hs.hotkey.bind(Utility.mash, "p", function()
-- 	local AppTitle = hs.application:title()
-- 	hs.alert.show(AppTitle)
-- end)

--------------------------------------------------

-- Activity Logger
-- Critical:
-- Time events
	-- docs » hs.timer http://www.hammerspoon.org/docs/hs.timer.html
-- Get application name, window title, etc.

-- -- React to application events
-- function applicationWatcher(appName, eventType, appObject)
-- 		-- hs.alert.show(appName)
-- 		-- hs.alert.show('eventType: '..eventType) -- number (concatenate to become string)
-- 		print('appObject from application watcher:')
-- 		print(appObject:title())
-- 		print(appObject)
-- 		print('--------------')
-- 		print('Event driven parse:')
-- 	  print('application: '..hs.window.focusedWindow():application():title())
-- 	  print('title: '..hs.window.focusedWindow():title())
-- 	  print('id: '..hs.window.focusedWindow():id())
-- 	  print('role: '..hs.window.focusedWindow():role())
-- 	  print('subrole: '..hs.window.focusedWindow():subrole())
-- 	  print('visibleWindows(): ')
-- 	  -- Source: https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
-- 	  for k, v in pairs( hs.window.visibleWindows() ) do
-- 		   print(k, v)
-- 		end
-- 		print('==============================')

-- 		-- check if application activate event (vs. close?)
-- 		if (eventType == hs.application.watcher.activated) then
-- 				-- hs.alert.show(appName)
-- 				-- -- if (appName == "Finder") then
-- 				-- -- 		-- Bring all Finder windows forward when one gets activated
-- 				-- -- 		appObject:selectMenuItem({"Window", "Bring All to Front"})
-- 				-- -- end
-- 		end
-- end
-- local appWatcher = hs.application.watcher.new(applicationWatcher)
-- -- appWatcher:start()

-- -- Keep working on this:
-- -- http://www.hammerspoon.org/docs/hs.uielement.html
-- -- Necessary for watching for change in application title
-- -- http://www.hammerspoon.org/docs/hs.uielement.watcher.html
-- hs.hotkey.bind(Utility.mash, "p", function()
-- 	print('*********************')
-- 	print('UI focusedElements')
-- 	print(hs.uielement.focusedElement():isApplication())
-- 	print(hs.uielement.focusedElement():isWindow())
-- 	print('role'..hs.uielement.focusedElement():role())
-- 	-- print('title'..hs.uielement.focusedElement():title())
-- 	if hs.uielement.focusedElement():selectedText() then
-- 		print('selectedText'..hs.uielement.focusedElement():selectedText())
-- 	else
-- 		print('No access to selectedText')
-- 	end

-- 	print('*********************')
-- end)


-- Cool:
-- Get location: docs » hs.location http://www.hammerspoon.org/docs/hs.location.html
-- Get lux values using brightness module (i.e. how dark/bright is room?)
-- Communicate over URL from chrome extension to log url changes


--------------------------------------------------

-- -- Only seems to work when called from terminal:
-- -- open -g hammerspoon://someAlert
-- hs.urlevent.bind("someAlert", function(eventName, params)
--     hs.alert.show("Received someAlert")
-- end)
-- IPC module is better

--------------------------------------------------
-- Things that didn't work
--------------------------------------------------

-- Shows little icons and allows you to press a letter to
-- switch between screens on the same page
-- Doesn't seem that useful and bad UI
-- hs.hotkey.bind(Utility.mash, "p", function()
-- 	-- hs.alert.show('hint?')
-- 	hs.hints.windowHints(nil)
-- end)


-- -- Not for spaces:
-- hs.hotkey.bind(Utility.mash, "p", function()
-- 	hs.window.focusedWindow():moveOneScreenEast()
-- 	hs.alert.show('Attempt')
-- end)