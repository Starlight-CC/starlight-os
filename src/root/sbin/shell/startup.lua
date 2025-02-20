term.clear()
local rootdir = shell.homeDir().."cmd/"

-- Setup aliases
shell.clearAlias("ls")
shell.clearAlias("dir")
shell.clearAlias("sh")
shell.clearAlias("cp")
shell.clearAlias("mv")
shell.clearAlias("rm")
shell.clearAlias("clr")
shell.clearAlias("rs")
shell.setAlias("ls", "/"..rootdir.."list.lua")
shell.setAlias("dir", "/"..rootdir.."list.lua")
shell.setAlias("sh", "/"..rootdir.."shell.lua")
shell.setAlias("cp", "/"..rootdir.."copy.lua")
shell.setAlias("mv", "/"..rootdir.."move.lua")
shell.setAlias("rm", "/"..rootdir.."delete.lua")
shell.setAlias("clr", "/"..rootdir.."clear.lua")
shell.setAlias("rs", "/"..rootdir.."redstone.lua")
shell.setAlias("shutdown", "/sys/serv/shutdown.lua")
shell.setAlias("reboot", "/sys/serv/reboot.lua")

rootdir = shell.homeDir().."start/"
if fs.exists(rootdir) and fs.isDir(rootdir) then
    local tFiles = fs.list(rootdir)
    for _, sFile in ipairs(tFiles) do
        local sPath = rootdir .. sFile
        if not fs.isDir(sPath) then
            shell.run("run "..sPath)
        end
    end
end
