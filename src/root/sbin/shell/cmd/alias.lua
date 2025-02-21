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
if #tArgs > 2 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. " <alias> <program>")
    return
end

local sAlias = tArgs[1]
local sProgram = tArgs[2]

if sAlias and sProgram then
    -- Set alias
    shell.setAlias(sAlias, sProgram)
elseif sAlias then
    -- Clear alias
    shell.clearAlias(sAlias)
else
    -- List aliases
    local tAliases = shell.aliases()
    local tList = {}
    for sAlias, sCommand in pairs(tAliases) do
        table.insert(tList, sAlias .. ":" .. sCommand)
    end
    table.sort(tList)
    textutils.pagedTabulate(tList)
end
