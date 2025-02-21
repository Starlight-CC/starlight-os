--[[
Made for use in StarlightOS
filed under GNU General Public License.
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
if #tArgs < 1 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: [arg] <string>")
    print("Usage: <string>")
    return
end

local vc = 0

local function move(ix,iy)
    local x,y = term.getCursorPos()
    if y == 19 then
        term.scroll(iy)
        term.setCursorPos(x+ix,19)
    else
        term.setCursorPos(x+ix,y+iy)
    end
end

local function go()
    if tArgs[1] == "-e" then
        for i,v in ipairs(tArgs) do

            if v == "/n" then
                local x,y = term.getCursorPos()
                term.setCursorPos(1,y)
                move(0,1)
            elseif v == "/c" then
                return "c"
            elseif v == "/b" then
                move(-1,0)
            elseif v == "/t" then
                move(4,0)
            elseif v == "/v" then
                vc = vc+1
                local x,y = term.getCursorPos()
                term.setCursorPos(1,y)
                move(vc*4,1)
            elseif i == 1 then
                --remove arg
            else
                term.write(v.." ")
            end
        end
    elseif tArgs[1] == "-n" then
        for i,v in ipairs(tArgs) do
            if i == 1 then
                --remove arg
            else
                term.write(v.." ")
            end
        end
        return "c"
    elseif tArgs[1] == "*" then
        for i,v in ipairs(tArgs) do
            if i == 1 then
                --remove arg
            else
                textutils.pagedTabulate(fs.list(shell.dir()))
            end
        end
    else
        for i,v in ipairs(tArgs) do
            term.write(v.." ")
        end
    end
end

local x,y = term.getCursorPos()
if go() == nil then
    local x,y = term.getCursorPos()
    term.setCursorPos(1,y)
    move(0,1)
end


