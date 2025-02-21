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
if #tArgs < 2 then
    print("Usage: addusr <name> <password>")
    return
end

local function contains(l,t)
    for i,v in ipairs(l) do
        if v == t then
            return true
        end
    end
    return false
end
    
if not contains(user[1],tArgs[1]) then
    fs.copy("/usr/*","home/"..os.username().."/")
else
    term.setTextColor(colors.red)
    print("User exists")
end