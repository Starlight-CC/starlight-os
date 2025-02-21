--[[
SPDX-FileCopyrightText: 2023 The CC: Tweaked Developers
SPDX-License-Identifier: MPL-2.0
Edited by Starlight-OS team for use in Starlight-OS.
Edits are filed under GNU General Public License.
    Copyright (C) 2025  StarlightOS

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>

    contacts-
      <https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/legal/contacts.md>
]]
local tArgs = { ... }
if #tArgs > 0 then
    print("This is an interactive Lua prompt.")
    print("To run a lua program, just type its name.")
    return
end

local pretty = require "pretty"
local exception = require "internal.exception"

local running = true
local tCommandHistory = {}
local tEnv = {
    ["exit"] = setmetatable({}, {
        __tostring = function() return "Type exit() to exit" end,
        __call = function() running = false end,
    }),
    ["_echo"] = function(...)
        return ...
    end,
}
setmetatable(tEnv, { __index = _ENV })

-- Replace our require with new instance that loads from the current directory
-- rather than from /rom/programs. This makes it more friendly to use and closer
-- to what you'd expect.
do
    local make_package = require "require".make
    local dir = shell.dir()
    _ENV.require, _ENV.package = make_package(_ENV, dir)
end

if term.isColour() then
    term.setTextColour(colours.blue)
end
print("Interactive Lua prompt.")
print("Call exit() to exit.")
term.setTextColour(colours.white)

local chunk_idx, chunk_map = 1, {}
while running do
    if term.isColour() then
        term.setTextColour( colors.green )
    end
    write("lua: ")
    term.setTextColour( colours.white )

    local input = read(nil, tCommandHistory, function(sLine)
        if settings.get("lua.autocomplete") then
            local nStartPos = string.find(sLine, "[a-zA-Z0-9_%.:]+$")
            if nStartPos then
                sLine = string.sub(sLine, nStartPos)
            end
            if #sLine > 0 then
                return textutils.complete(sLine, tEnv)
            end
        end
        return nil
    end)
    if input:match("%S") and tCommandHistory[#tCommandHistory] ~= input then
        table.insert(tCommandHistory, input)
    end
    if settings.get("lua.warn_against_use_of_local") and input:match("^%s*local%s+") then
        if term.isColour() then
            term.setTextColour(colours.yellow)
        end
       print("To access local variables in later inputs, remove the local keyword.")
       term.setTextColour(colours.white)
    end

    local name, offset = "=lua[" .. chunk_idx .. "]", 0

    local func, err = load(input, name, "t", tEnv)
    if load("return " .. input) then
        -- We wrap the expression with a call to _echo(...), which prevents tail
        -- calls (and thus confusing errors). Note we check this is a valid
        -- expression separately, to avoid accepting inputs like `)--` (which are
        -- parsed as `_echo()--)`.
        func = load("return _echo(" .. input .. "\n)", name, "t", tEnv)
        offset = 13
    end

    if func then
        chunk_map[name] = { contents = input, offset = offset }
        chunk_idx = chunk_idx + 1

        local results = table.pack(exception.try(func))
        if results[1] then
            for i = 2, results.n do
                local value = results[i]
                local ok, serialised = pcall(pretty.pretty, value, {
                    function_args = settings.get("lua.function_args"),
                    function_source = settings.get("lua.function_source"),
                })
                if ok then
                    pretty.print(serialised)
                else
                    print(tostring(value))
                end
            end
        else
            printError(results[2])
            exception.report(results[2], results[3], chunk_map)
        end
    else
        local parser = require "internal.syntax.init"
        if parser.parse_repl(input) then printError(err) end
    end

end
