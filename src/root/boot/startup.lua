term.clear()
local completion = require("shell.completion")
local rootdir = "sbin/shell/cmd/"

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

-- Setup completion functions

local function completePastebinPut(shell, text, previous)
    if previous[2] == "put" then
        return fs.complete(text, shell.dir(), true, false)
    end
end

shell.setCompletionFunction(rootdir.."link.lua", completion.build(completion.dir,completion.dir))
shell.setCompletionFunction(rootdir.."alias.lua", completion.build(nil, completion.program))
shell.setCompletionFunction(rootdir.."cd.lua", completion.build(completion.dir))
shell.setCompletionFunction(rootdir.."clear.lua", completion.build({ completion.choice, { "screen", "palette", "all" } }))
shell.setCompletionFunction(rootdir.."copy.lua", completion.build(
    { completion.dirOrFile, true },
    completion.dirOrFile
))
shell.setCompletionFunction(rootdir.."delete.lua", completion.build({ completion.dirOrFile, many = true }))
shell.setCompletionFunction(rootdir.."drive.lua", completion.build(completion.dir))
shell.setCompletionFunction(rootdir.."edit.lua", completion.build(completion.file))
shell.setCompletionFunction(rootdir.."run.lua", completion.build(completion.file))
shell.setCompletionFunction(rootdir.."eject.lua", completion.build(completion.peripheral))
shell.setCompletionFunction(rootdir.."gps.lua", completion.build({ completion.choice, { "host", "host ", "locate" } }))
shell.setCompletionFunction(rootdir.."help.lua", completion.build(completion.help))
shell.setCompletionFunction(rootdir.."id.lua", completion.build(completion.peripheral))
shell.setCompletionFunction(rootdir.."label.lua", completion.build(
    { completion.choice, { "get", "get ", "set ", "clear", "clear " } },
    completion.peripheral
))
shell.setCompletionFunction(rootdir.."list.lua", completion.build(completion.dir))
shell.setCompletionFunction(rootdir.."mkdir.lua", completion.build({ completion.dir, many = true }))

local complete_monitor_extra = { "scale" }
shell.setCompletionFunction(rootdir.."monitor.lua", completion.build(
    function(shell, text, previous)
        local choices = completion.peripheral(shell, text, previous, true)
        for _, option in pairs(completion.choice(shell, text, previous, complete_monitor_extra, true)) do
            choices[#choices + 1] = option
        end
        return choices
    end,
    function(shell, text, previous)
        if previous[2] == "scale" then
            return completion.peripheral(shell, text, previous, true)
        else
            return completion.programWithArgs(shell, text, previous, 3)
        end
    end,
    {
        function(shell, text, previous)
            if previous[2] ~= "scale" then
                return completion.programWithArgs(shell, text, previous, 3)
            end
        end,
        many = true,
    }
))

shell.setCompletionFunction(rootdir.."move.lua", completion.build(
    { completion.dirOrFile, true },
    completion.dirOrFile
))
shell.setCompletionFunction(rootdir.."redstone.lua", completion.build(
    { completion.choice, { "probe", "set ", "pulse " } },
    completion.side
))
shell.setCompletionFunction(rootdir.."rename.lua", completion.build(
    { completion.dirOrFile, true },
    completion.dirOrFile
))
shell.setCompletionFunction(rootdir.."shell.lua", completion.build({ completion.programWithArgs, 2, many = true }))
shell.setCompletionFunction(rootdir.."type.lua", completion.build(completion.dirOrFile))
shell.setCompletionFunction(rootdir.."set.lua", completion.build({ completion.setting, true }))
shell.setCompletionFunction(rootdir.."advanced/bg.lua", completion.build({ completion.programWithArgs, 2, many = true }))
shell.setCompletionFunction(rootdir.."advanced/fg.lua", completion.build({ completion.programWithArgs, 2, many = true }))
shell.setCompletionFunction(rootdir.."fun/dj.lua", completion.build(
    { completion.choice, { "play", "play ", "stop " } },
    completion.peripheral
))
shell.setCompletionFunction(rootdir.."fun/speaker.lua", completion.build(
    { completion.choice, { "play ", "sound ", "stop " } },
    function(shell, text, previous)
        if previous[2] == "play" then return completion.file(shell, text, previous, true)
        elseif previous[2] == "stop" then return completion.peripheral(shell, text, previous, false)
        end
    end,
    function(shell, text, previous)
        if previous[2] == "play" then return completion.peripheral(shell, text, previous, false)
        end
    end
))
shell.setCompletionFunction(rootdir.."fun/advanced/paint.lua", completion.build(completion.file))
shell.setCompletionFunction(rootdir.."http/pastebin.lua", completion.build(
    { completion.choice, { "put ", "get ", "run " } },
    completePastebinPut
))
shell.setCompletionFunction(rootdir.."rednet/chat.lua", completion.build({ completion.choice, { "host ", "join " } }))
shell.setCompletionFunction(rootdir.."command/exec.lua", completion.build(completion.command))
shell.setCompletionFunction(rootdir.."http/wget.lua", completion.build({ completion.choice, { "run " } }))

if turtle then
    shell.setCompletionFunction(rootdir.."turtle/go.lua", completion.build(
        { completion.choice, { "left", "right", "forward", "back", "down", "up" }, true, many = true }
    ))
    shell.setCompletionFunction(rootdir.."turtle/turn.lua", completion.build(
        { completion.choice, { "left", "right" }, true, many = true }
    ))
    shell.setCompletionFunction(rootdir.."turtle/equip.lua", completion.build(
        nil,
        { completion.choice, { "left", "right" } }
    ))
    shell.setCompletionFunction(rootdir.."turtle/unequip.lua", completion.build(
        { completion.choice, { "left", "right" } }
    ))
end

-- Run system autorun files
if fs.exists("/ect/autorun/") and fs.isDir("/ect/autorun/") then
    local tFiles = fs.list("/ect/autorun/")
    for _, sFile in ipairs(tFiles) do
        local sPath = "/ect/autorun/" .. sFile
        if not fs.isDir(sPath) then
            shell.run("run "..sPath)
        end
    end
end
