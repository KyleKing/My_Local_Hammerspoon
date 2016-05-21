local Utility = require("Utility")

print('')
print('>> Loading Mac Hardware for:')
print('   Battery Watcher')

--------------------------------------------------
-- Battery Status Watcher
--------------------------------------------------

-- Basic Battery Watcher (Three additional examples are also available
-- (example code from: https://github.com/Hammerspoon/hammerspoon/issues/166#issuecomment-68320784)
pct_prev = nil

function BattAlert(str, val)
  hs.alert.show(string.format(str, val))
end

function batt_watch_low()
  pct = hs.battery.percentage()
  pct_int = math.floor(pct)
  if type(pct_int) == 'number' then
    if pct_int ~= pct_prev and not hs.battery.isCharging() and pct_int < 50 then
      BattAlert("I need NUTELLA! %d%% left!", pct_int)
      if pct_int < 30 then
        BattAlert("ABOUT TIME TO CARE ABOUT ME! %d%% left!", pct_int)
      end
      if pct_int < 20 then
        BattAlert("Prepare for war! %d%% left!", pct_int)
      end
      if pct_int < 15 then
        BattAlert("This ain't funny. %d%% left!", pct_int)
      end
      if pct_int < 10 then
        BattAlert("RED ALERT! %d%% left!", pct_int)
      end
    end
    pct_prev = pct_int
  else
    hs.alert.show("GIVE ME POWER! Running Low!")
  end
end
hs.battery.watcher.new(batt_watch_low):start()
