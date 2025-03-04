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

local function sanity_checks(source, dest)
    if fs.exists(dest) then
        printError("Destination exists")
        return false
    elseif fs.isReadOnly(dest) then
        printError("Destination is read-only")
        return false
    elseif fs.isDriveRoot(source) then
        printError("Cannot move mount /" .. source)
        return false
    elseif fs.isReadOnly(source) then
        printError("Cannot move read-only file /" .. source)
        return false
    end
    return true
end

if #tFiles > 0 then
    for _, sFile in ipairs(tFiles) do
        if fs.isDir(sDest) then
            local dest = fs.combine(sDest, fs.getName(sFile))
            if sanity_checks(sFile, dest) then
                fs.move(sFile, dest)
            end
        elseif #tFiles == 1 then
            if sanity_checks(sFile, sDest) then
                fs.move(sFile, sDest)
            end
        else
            printError("Cannot overwrite file multiple times")
            return
        end
    end
else
    printError("No matching files")
end
