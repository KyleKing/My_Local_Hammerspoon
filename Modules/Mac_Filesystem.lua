local Utility = require("./Modules/Utility")

initLog.d('')
initLog.d('>> Loading Mac Filesystem for:')
initLog.d('   Reload Hammerspoon on File Change')
initLog.d('   Toggle Dot Files')
initLog.d('   Compile Applescript Files')

----------------------------------------------------
-- Reload Hammerspoon Configuration
--------------------------------------------------

-- Reload Configuration with Shortcut
function manualReload()
  hs.reload()
end
hs.hotkey.bind(Utility.mash, "r", manualReload)

-- Automatically Reload Configuration:
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME").."/.hammerspoon/", reloadConfig):start()

--------------------------------------------------
-- Show or Hide Dot Files
--------------------------------------------------

local DotCMD1 = 'do shell script "defaults write com.apple.finder AppleShowAllFiles '
local DotCMD2 = '; killall Finder /System/Library/CoreServices/Finder.app"'
function hideFiles()
    ok,result = hs.applescript( DotCMD1..'NO'..DotCMD2 )
    hs.alert.show("Hiding Hidden Files")
end
function showFiles()
    ok,result = hs.applescript( DotCMD1..'YES'..DotCMD2 )
    hs.alert.show("Dot File and System Files Shown")
end

--------------------------------------------------
-- Automatically Recompile Applescript Files
--------------------------------------------------

function reloadApplescript(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-12) == ".applescript" then
            doReload = true
        end
    end
    print('(reloadApplescript) doReload: '..tostring(doReload))
    if doReload then
        y = os.execute('cd  '..Utility.scptPath..'; bash compile.sh')
        print('Reload Result='..y)
    end
end
hs.pathwatcher.new(Utility.scptPath, reloadApplescript):start()
