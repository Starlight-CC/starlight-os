local root = "sys/shell/rom/programs/"
local completion = require("cc.shell.completion")

shell.clearAlias("ls")
shell.setAlias("ls",root.."list.lua")
shell.setAlias("list",root.."list.lua")
shell.setCompletionFunction(root.."list.lua", completion.build(completion.dir))

shell.setAlias("cd",root.."cd.lua")
shell.setCompletionFunction("rom/programs/cd.lua", completion.build(completion.dir))

shell.setAlias("lua",root.."lua.lua")

term.clear()
term.setCursorPos(1,1)
shell.run("/sys/shell/shell.lua")