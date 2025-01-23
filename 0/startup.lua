local roota = "/sys/shell/rom/programs/"
local rootc = "sys/shell/rom/programs/"
local completion = require("cc.shell.completion")

shell.clearAlias("ls")
shell.setAlias("ls",roota.."list.lua")
shell.setAlias("list",roota.."list.lua")
shell.setCompletionFunction(rootc.."list.lua", completion.build(completion.dir))

shell.clearAlias("sh")
shell.setAlias("sh",roota.."shell.lua")
shell.setAlias("shell",roota.."shell.lua")

shell.setAlias("cd",roota.."cd.lua")
shell.setCompletionFunction(rootc.."cd.lua", completion.build(completion.dir))

shell.setAlias("lua",roota.."lua.lua")
shell.setAlias("pwd",roota.."pwd.lua")

term.clear()
term.setCursorPos(1,1)
shell.run("/sys/shell/shell.lua")