# My Hammerspoon Config

Hammerspoon is a great utility to simplify really mundane, but useful things. For example, I have multiple applications (iTunes, Spotify, and Streamkeys - for chrome) that expect input using the <kbd>f7</kbd> (Rewind), <kbd>f8</kbd> (Play/Pause), and <kbd>f9</kbd> (Fast forward) keys. Usually Spotify is the lowest in this hierarchy, so I would have to manually change songs; however with Hammerspoon, there is a really easy alternative to map the commands to a second set of shortcut keys -> so I wrote the song controller in `Mac_Sound.lua`.

I heavily use Alfred to trigger many of the Hammerspoon/applescript functions and can pass arguments through my custom workflow. The workflow will be released in the next month, but the devlopment version is available here: https://github.com/KyleKing/My-Programming-Sketchbook/tree/master/Alfred/user.workflow.D67DE9BE-47D0-4727-BF34-DFA7132EDCD1

## Rundown of the included Files

- ```HelloWorld.lua```: My notes as I followed the getting started guide
- ```Mac_*.lua```: Useful utilities for battery watching, spotify, and dot files, with more to come
- ```Utility.lua```: Set of functions used across this app, such as printing proper JSON
	- ```dkjson.lua```: module used within ```Utility.lua```
- ```init.lua```: An index file that triggers successive files to be run and includes the AlfredFunction()
- ```windowTiling.lua```: The most essential of all the shortcuts
- ```z_In Progress.lua```: Mostly notes and functions that may work!
- ```z_debugging.lua```: Playing around with some debugging utilities, but haven't really used
