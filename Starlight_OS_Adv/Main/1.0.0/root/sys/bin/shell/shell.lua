term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.blue)
print("StarlightOS 1.0.0")
print("type GUI for graphical UI")

local rootDir = "/Sys/bin/shell/shellOverides/rom/programs/"
local completion = require("cc.shell.completion")
local tmp = {}

for i,v in ipairs(shell.aliases()) do
    shell.clearAlias(v)
end
for i,v in ipairs(overides[1]) do
    shell.clearAlias(v)
    table.insert(tmp,i,v)
end
for i,v in ipairs(overides[2]) do
    shell.setAlias(tmp[i],v)
end

-- Setup aliases
shell.setAlias("ls", "list")
shell.setAlias("dir", "list")
shell.setAlias("cp", "copy")
shell.setAlias("mv", "move")
shell.setAlias("rm", "delete")
shell.setAlias("clr", "clear")
shell.setAlias("rs", "redstone")
shell.setAlias("sh", "shell")
if term.isColor() then
    shell.setAlias("background", "bg")
    shell.setAlias("foreground", "fg")
end

-- Setup completion functions

local function completePastebinPut(shell, text, previous)
    if previous[2] == "put" then
        return fs.complete(text, shell.dir(), true, false)
    end
end

shell.setCompletionFunction(rootDir.."alias.lua", completion.build(nil, completion.program))
shell.setCompletionFunction(rootDir.."cd.lua", completion.build(completion.dir))
shell.setCompletionFunction(rootDir.."clear.lua", completion.build({ completion.choice, { "screen", "palette", "all" } }))
shell.setCompletionFunction(rootDir.."copy.lua", completion.build(
    { completion.dirOrFile, true },
    completion.dirOrFile
))
shell.setCompletionFunction(rootDir.."delete.lua", completion.build({ completion.dirOrFile, many = true }))
shell.setCompletionFunction(rootDir.."drive.lua", completion.build(completion.dir))
shell.setCompletionFunction(rootDir.."edit.lua", completion.build(completion.file))
shell.setCompletionFunction(rootDir.."eject.lua", completion.build(completion.peripheral))
shell.setCompletionFunction(rootDir.."gps.lua", completion.build({ completion.choice, { "host", "host ", "locate" } }))
shell.setCompletionFunction(rootDir.."help.lua", completion.build(completion.help))
shell.setCompletionFunction(rootDir.."id.lua", completion.build(completion.peripheral))
shell.setCompletionFunction(rootDir.."label.lua", completion.build(
    { completion.choice, { "get", "get ", "set ", "clear", "clear " } },
    completion.peripheral
))
shell.setCompletionFunction(rootDir.."list.lua", completion.build(completion.dir))
shell.setCompletionFunction(rootDir.."mkdir.lua", completion.build({ completion.dir, many = true }))

local complete_monitor_extra = { "scale" }
shell.setCompletionFunction(rootDir.."monitor.lua", completion.build(
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

shell.setCompletionFunction(rootDir.."move.lua", completion.build(
    { completion.dirOrFile, true },
    completion.dirOrFile
))
shell.setCompletionFunction(rootDir.."redstone.lua", completion.build(
    { completion.choice, { "probe", "set ", "pulse " } },
    completion.side
))
shell.setCompletionFunction(rootDir.."rename.lua", completion.build(
    { completion.dirOrFile, true },
    completion.dirOrFile
))
shell.setCompletionFunction(rootDir.."shell.lua", completion.build({ completion.programWithArgs, 2, many = true }))
shell.setCompletionFunction(rootDir.."type.lua", completion.build(completion.dirOrFile))
shell.setCompletionFunction(rootDir.."set.lua", completion.build({ completion.setting, true }))
shell.setCompletionFunction(rootDir.."advanced/bg.lua", completion.build({ completion.programWithArgs, 2, many = true }))
shell.setCompletionFunction(rootDir.."advanced/fg.lua", completion.build({ completion.programWithArgs, 2, many = true }))
shell.setCompletionFunction(rootDir.."fun/dj.lua", completion.build(
    { completion.choice, { "play", "play ", "stop " } },
    completion.peripheral
))
shell.setCompletionFunction(rootDir.."fun/speaker.lua", completion.build(
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
shell.setCompletionFunction(rootDir.."fun/advanced/paint.lua", completion.build(completion.file))
shell.setCompletionFunction(rootDir.."http/pastebin.lua", completion.build(
    { completion.choice, { "put ", "get ", "run " } },
    completePastebinPut
))
shell.setCompletionFunction(rootDir.."rednet/chat.lua", completion.build({ completion.choice, { "host ", "join " } }))
shell.setCompletionFunction(rootDir.."command/exec.lua", completion.build(completion.command))
shell.setCompletionFunction(rootDir.."http/wget.lua", completion.build({ completion.choice, { "run " } }))

if turtle then
    shell.setCompletionFunction(rootDir.."turtle/go.lua", completion.build(
        { completion.choice, { "left", "right", "forward", "back", "down", "up" }, true, many = true }
    ))
    shell.setCompletionFunction(rootDir.."turtle/turn.lua", completion.build(
        { completion.choice, { "left", "right" }, true, many = true }
    ))
    shell.setCompletionFunction(rootDir.."turtle/equip.lua", completion.build(
        nil,
        { completion.choice, { "left", "right" } }
    ))
    shell.setCompletionFunction(rootDir.."turtle/unequip.lua", completion.build(
        { completion.choice, { "left", "right" } }
    ))
end
