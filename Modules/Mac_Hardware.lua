local Utility = require("./Modules/Utility")

initLog.d('')
initLog.d('>> Loading Mac Hardware for:')
initLog.d('   Battery Watcher')

--------------------------------------------------
-- Battery Status Watcher
--------------------------------------------------

-- Basic Battery Watcher (Three additional examples are also available
-- (example code from: https://github.com/Hammerspoon/hammerspoon/issues/166#issuecomment-68320784)
pct_prev = nil

function batt_watch_low()
  -- Utility.BattAlert("WATCHING %d%% left!", 12)
  pct = hs.battery.percentage()
  pct_int = math.floor(pct)
  if type(pct_int) == 'number' then
    if pct_int ~= pct_prev and not hs.battery.isCharging() and pct_int < 20 then
      if pct_int % 3 == 0 then
        Utility.BattAlert("I need NUTELLA! %d%% left!", pct_int)
      end
      if pct_int < 12 then
        Utility.BattAlert("ABOUT TIME TO CARE ABOUT ME! %d%% left!", pct_int)
      end
      if pct_int < 9 then
        Utility.BattAlert("Prepare for war! %d%% left!", pct_int)
      end
      if pct_int < 7 then
        Utility.BattAlert("This ain't funny. %d%% left!", pct_int)
      end
      if pct_int < 5 then
        Utility.BattAlert("RED ALERT! %d%% left!", pct_int)
      end
    end
    pct_prev = pct_int
  else
    hs.alert.show("GIVE ME POWER! Running Low!")
  end
end
hs.battery.watcher.new(batt_watch_low):start()
