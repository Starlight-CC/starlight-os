--Copyright (C) 2025  Starlight-CC
theme = {}
theme.main = colors.cyan
theme.sec = colors.purple


local multishell = multishell -- detects if it is a advanced computer
local parentShell = _G.shell -- prev shell if nil make new shell
local parentTerm = term.current() -- term handle
local aliases = {} -- alias table
_G.shell = {} -- api
local sDir = parentShell and parentShell.dir() or "/" or os.home() -- Working dir
local sMode = "safe" -- shell mode {safe,cmd,auth,lock}
local Exit = false
local make_package = dofile("sys/modules/require.la").make -- custom require
local function createShellEnv(dir)
    local env = { shell = shell, multishell = multishell }
    env.require, env.package = make_package(env, dir)
    return env
end
local require -- Set up a dummy require
do
    local env = setmetatable(createShellEnv("/sbin/shell"), { __index = _ENV })
    require = env.require
end
expect = require "cc.expect"
local exception = require "internal.exception"
local commands = require("shellCMD") -- Shell commands

function os.username() return "root" end
function os.hostname() return "cc" end
function shell.dir() return sDir end
function shell.cd(e) if sMode == "cmd" then sDir = e end end

local function tokenise(...) -- convert arg string to table
    local line = table.concat({ ... }, " ")
    local words = {}
    local quoted = false
    for match in string.gmatch(line .. "\"", "(.-)\"") do
        if quoted then
            table.insert(words, match)
        else
            for m in string.gmatch(match, "[^ \t]+") do
                table.insert(words, m)
            end
        end
        quoted = not quoted
    end
    return words
end

function fs.getFileExtention(f)
    if string.find(f,".") ~= nil then
        local s = f
        local d
        while true do
            d = string.find(s,".")
            if d == nil then
                return S
            end
            s = string.sub(s,d)
        end
    end
    return ""
end

function shell.exec(c,...) -- run a command
    local tArgs = ...
    if c == nil then 
        return
    end
    if sMode ~= "lock" then
        local dir = fs.combine("/proc",string.sub(c,1,string.find(c,".")-1))
        if commands.find(c) then
            sMode = "cmd"
            local cmd = commands.exec[tostring(c)]
            local retFunc = cmd(table.unpack(tokenise(tArgs)))
            pcall(retFunc)
            sMode = "safe"
        elseif fs.exists(fs.combine(shell.dir(),c)) then
            cmd = fs.combine(shell.dir(),c)
            local args = tokenise(tArgs)
            fs.makeDir(fs.combine("/proc",string.sub(c,1,string.find(c,".")-1)))
            local env = setmetatable(createShellEnv(fs.getDir(cmd)), { __index = _G })
            env.arg = table.unpack(args)
            os.run(env,cmd,args)
        else
            term.setTextColor(colors.red)
            print("No command or file found")
        end
    end
end

function shell.run(...)
    if sMode ~= "lock" then
        local tArgs = tokenise(...)
        shell.exec(tArgs[1],table.unpack(tArgs,2))
    end
end

function shell.exit() -- guess "hint: check the name"
    if parentShell == nil then
        term.setTextColor(colors.red)
        print("Top level shell cannot be terminated")
    else
        if sMode == "cmd" then
            Exit = true
            _G.shell = parentShell
        end
    end
end

function shell.resolve(path) -- path handling
    expect(1, path, "string")
    local sStartChar = string.sub(path, 1, 1)
    if sStartChar == "/" or sStartChar == "\\" then
        return fs.combine("/", path)
    else
        return fs.combine(sDir, path)
    end
end

tArgs = nil
tArgs = {...}
if #tArgs > 0 then
    
else
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(theme.sec)
    print([[SShell Copyright (C) 2025  Starlight-CC
for details type 'man c'.
    ]])
    function printHead()
        term.setTextColor(theme.main)
        local pdir = os.util.subHome(sDir)
        term.write(os.username().."@"..os.hostname()..":"..pdir.."$ ")
        term.setTextColor(colors.white)
        term.setCursorBlink(true)
    end

    local tCommandHistory = {}
    while not Exit do
        printHead()

        local ok, result
        local co = coroutine.create(read)
        assert(coroutine.resume(co, nil, tCommandHistory, complete))

        while coroutine.status(co) ~= "dead" do
            local event = table.pack(os.pullEvent())
            if event[1] == "file_transfer" then
                local _, h = term.getSize()
                local _, y = term.getCursorPos()
                if y == h then
                    term.scroll(1)
                    term.setCursorPos(1, y)
                else
                    term.setCursorPos(1, y + 1)
                end
                term.setCursorBlink(false)

                local ok, err = require("internal.import")(event[2].getFiles())
                if not ok and err then printError(err) end

                printHead()
                term.setCursorBlink(true)
                event = { "term_resize", n = 1 }
            end

            if result == nil or event[1] == result or event[1] == "terminate" then
                ok, result = coroutine.resume(co, table.unpack(event, 1, event.n))
                if not ok then error(result, 0) end
            end
        end

        if result:match("%S") and tCommandHistory[#tCommandHistory] ~= result then
            table.insert(tCommandHistory, result)
        end
        shell.run(result)
    end
end
