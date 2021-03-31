local Utility = require("./Modules/Utility")

initLog.d('')
initLog.d('>> Loading Mac Filesystem for:')
initLog.d('   Reload Hammerspoon on File Change')
initLog.d('   Toggle Dot Files')
initLog.d('   Compile Applescript Files')

----------------------------------------------------
-- Reload Hammerspoon Configuration
--------------------------------------------------

-- Make sure persistent data file is present
if Utility.file_exists(Utility.file) then
    initLog.d(Utility.file..' exists and will not be overwritten')
else
    -- Source: http://stackoverflow.com/a/16368141/3219667
    infile = io.open(Utility.file..".back", "r")
    instr = infile:read("*a")
    infile:close()

    outfile = io.open(Utility.file, "w")
    outfile:write(instr)
    outfile:close()
end

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

NotifyUser('Fresh Start', 'HS Config Loaded')

--------------------------------------------------
-- Other Filesystem utilities
--------------------------------------------------

-- Show or hide dot files
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

-- Automatically Recompile Applescript Files
function reloadApplescript(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-12) == ".applescript" then
            doReload = true
        end
    end
    print('(reloadApplescript) doReload: '..tostring(doReload))
    if doReload then
        -- FIXME: Currently opens Safari whenever run?
        hs.notify.new({title="HS", informativeText='Re-Compiled Applescript'}):send()

        -- y = os.execute('cd  '..Utility.scptPath..'; bash compile.sh')
        -- print('cd  '..Utility.scptPath..'; bash compile.sh')

        -- Run compile.sh from python:
        local result = Utility.captureNEW( 'cd  '..Utility.scptPath..'; python runScriptFrom.py' )
        print('\nCompiling Applescript result:\n'..result..'\n')
    end
end
-- FIXME: This isn't running?
hs.pathwatcher.new(Utility.scptPath, reloadApplescript):start()
