local Utility = require("./Modules/Utility")

initLog.d('')
initLog.d('>> Loading Browser Tools:')

hs.hotkey.bind(Utility.mash, "o", function()
	Utility.launchWebView( 'https://learnxinyminutes.com/docs/bash', hs.window.focusedWindow() )
end)

function learnXinY( language )
	-- -- initLog.d(language)
	-- -- initLog.d('https://learnxinyminutes.com/docs/'..language )
	-- Utility.openURL( 'https://learnxinyminutes.com/docs/'..language )
	Utility.launchWebView( 'https://learnxinyminutes.com/docs/'..language, hs.window.focusedWindow() )
end
