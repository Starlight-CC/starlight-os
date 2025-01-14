local sys = require ("/boot/sys/sys")

--loads globalAPIs
sys.loadGlobalAPIs()

if fs.exists("/boot/startup.lua")
    shell.run("/boot/startup.lua")
end
