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
if #tArgs < 2 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. " <source> <destination>")
    return
end

local sSource = shell.resolve(tArgs[1])
local sDest = shell.resolve(tArgs[2])
local tFiles = fs.find(sSource)
if #tFiles > 0 then
    for _, sFile in ipairs(tFiles) do
        if fs.isDir(sDest) then
            fs.copy(sFile, fs.combine(sDest, fs.getName(sFile)))
        elseif #tFiles == 1 then
            if fs.exists(sDest) then
                 printError("Destination exists")
            elseif fs.isReadOnly(sDest) then
                printError("Destination is read-only")
            elseif fs.getFreeSpace(sDest) < fs.getSize(sFile) then
                printError("Not enough space")
            else
                 fs.copy(sFile, sDest)
            end
        else
            printError("Cannot overwrite file multiple times")
            return
        end
    end
else
    printError("No matching files")
end
