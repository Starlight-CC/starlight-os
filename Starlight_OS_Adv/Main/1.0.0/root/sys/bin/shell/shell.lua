local completion = require("cc.shell.completion")

--custom LS and list 
shell.clearAlias("ls")
shell.setCompletionFunction("/sys/bin/shell/ls.lua", completion.build(completion.dir))
shell.setAlias("list", "/sys/bin/shell/ls.lua")
shell.setAlias("ls", "/sys/bin/shell/ls.lua")