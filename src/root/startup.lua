local function unbios(path, ...)
    -- UnBIOS by JackMacWindows
    -- This will undo most of the changes/additions made in the BIOS, but some things may remain wrapped if `debug` is unavailable
    -- To use, just place a `bios.lua` in the root of the drive, and run this program
    -- Here's a list of things that are irreversibly changed:
    -- * both `bit` and `bit32` are kept for compatibility
    -- * string metatable blocking (on old versions of CC)
    -- In addition, if `debug` is not available these things are also irreversibly changed:
    -- * old Lua 5.1 `load` function (for loading from a function)
    -- * `loadstring` prefixing (before CC:T 1.96.0)
    -- * `http.request`
    -- * `os.shutdown` and `os.reboot`
    -- * `peripheral`
    -- * `turtle.equip[Left|Right]`
    -- Licensed under the MIT license
    _G._HOST = _G._HOST.." (UnBIOS)"
    local old_dofile = _G.dofile
    local kernelArgs = table.pack(...)
    local keptAPIs = {bit32 = true, bit = true, ccemux = true, config = true, coroutine = true, debug = true, ffi = true, fs = true, http = true, io = true, jit = true, mounter = true, os = true, periphemu = true, peripheral = true, redstone = true, rs = true, term = true, utf8 = true, _HOST = true, _VERSION = true, assert = true, collectgarbage = true, error = true, gcinfo = true, getfenv = true, getmetatable = true, ipairs = true, load = true, loadstring = true, math = true, newproxy = true, next = true, pairs = true, pcall = true, rawequal = true, rawget = true, rawlen = true, rawset = true, select = true, setfenv = true, setmetatable = true, string = true, table = true, tonumber = true, tostring = true, type = true, unpack = true, xpcall = true, turtle = true, pocket = true, commands = true, _G = true, sound = true }
    local t = {}
    for k in pairs(_G) do if not keptAPIs[k] and not userGlobals[k] then table.insert(t, k) end end
    for _,k in ipairs(t) do _G[k] = nil end
    local native = monitor or _G.term.native()
    for _, method in ipairs { "nativePaletteColor", "nativePaletteColour", "screenshot" } do
        native[method] = _G.term[method]
    end
    _G.term = native
    _G.http.checkURL = _G.http.checkURLAsync
    _G.http.websocket = _G.http.websocketAsync
    if _G.commands then _G.commands = _G.commands.native end
    if _G.turtle then _G.turtle.native, _G.turtle.craft = nil end
    local delete = {os = {"pullEventRaw", "pullEvent", "run", "loadAPI", "unloadAPI", "sleep"}, http = {"get", "post", "put", "delete", "patch", "options", "head", "trace", "listen", "checkURLAsync", "websocketAsync"}, fs = {"complete", "isDriveRoot"}}
    for k,v in pairs(delete) do for _,a in ipairs(v) do _G[k][a] = nil end end
    -- Set up TLCO
    -- This functions by crashing `rednet.run` by removing `os.pullEventRaw`. Normally
    -- this would cause `parallel` to throw an error, but we replace `error` with an
    -- empty placeholder to let it continue and return without throwing. This results
    -- in the `pcall` returning successfully, preventing the error-displaying code
    -- from running - essentially making it so that `os.shutdown` is called immediately
    -- after the new BIOS exits.
    --
    -- From there, the setup code is placed in `term.native` since it's the first
    -- thing called after `parallel` exits. This loads the new BIOS and prepares it
    -- for execution. Finally, it overwrites `os.shutdown` with the new function to
    -- allow it to be the last function called in the original BIOS, and returns.
    -- From there execution continues, calling the `term.redirect` dummy, skipping
    -- over the error-handling code (since `pcall` returned ok), and calling
    -- `os.shutdown()`. The real `os.shutdown` is re-added, and the new BIOS is tail
    -- called, which effectively makes it run as the main chunk.
    local olderror = error
    _G.error = function() end
    _G.term.redirect = function() end
    function _G.term.native()
        _G.term.native = nil
        _G.term.redirect = nil
        _G.error = olderror
        term.setBackgroundColor(32768)
        term.setTextColor(1)
        term.setCursorPos(1, 1)
        term.setCursorBlink(true)
        local fn
        if type(path) == "function" then
            fn = path
        else
            local file = fs.open(path, "r")
            if file == nil then
                term.setCursorBlink(false)
                term.setTextColor(16384)
                term.write("Could not find init. Boot cannot continue.")
                term.setCursorPos(1, 2)
                term.write("Press any key to continue")
                coroutine.yield("key")
                os.shutdown()
            end
            local err
            fn, err = loadstring(file.readAll(), "=init")
            file.close()
            if fn == nil then
                term.setCursorBlink(false)
                term.setTextColor(16384)
                term.write("Could not load init. Boot cannot continue.")
                term.setCursorPos(1, 2)
                term.write(err)
                term.setCursorPos(1, 3)
                term.write("Press any key to continue")
                coroutine.yield("key")
                os.shutdown()
            end
        end
        setfenv(fn, _G)
        local oldshutdown = os.shutdown
        os.shutdown = function()
            os.shutdown = oldshutdown
            return fn(table.unpack(kernelArgs, 1, kernelArgs.n))
        end
    end
    if debug then
        -- Restore functions that were overwritten in the BIOS
        -- Apparently this has to be done *after* redefining term.native
        local function restoreValue(tab, idx, name, hint)
            local i, key, value = 1, debug.getupvalue(tab[idx], hint)
            while key ~= name and not (key == nil and i > 1) do
                key, value = debug.getupvalue(tab[idx], i)
                i=i+1
            end
            tab[idx] = value or tab[idx]
        end
        restoreValue(_G, "loadstring", "nativeloadstring", 1)
        restoreValue(_G, "load", "nativeload", 5)
        restoreValue(http, "request", "nativeHTTPRequest", 3)
        restoreValue(os, "shutdown", "nativeShutdown", 1)
        restoreValue(os, "reboot", "nativeReboot", 1)
        if turtle then
            restoreValue(turtle, "equipLeft", "v", 1)
            restoreValue(turtle, "equipRight", "v", 1)
        end
        do
            local i, key, value = 1, debug.getupvalue(peripheral.isPresent, 2)
            while key ~= "native" and key ~= nil do
                key, value = debug.getupvalue(peripheral.isPresent, i)
                i=i+1
            end
            _G.peripheral = value or peripheral
        end
        -- Restore Discord plugin in CraftOS-PC
        if debug.getupvalue(old_dofile, 2) == "status" then
            local _, status = debug.getupvalue(old_dofile, 2)
            _, _G.discord = debug.getupvalue(status, 4)
        end
    end
    coroutine.yield()
end
unbios("init",{craftos=true})