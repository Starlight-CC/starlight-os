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

-- Get all the files in the directory
local sDir = shell.dir()
if tArgs[1] ~= nil then
    sDir = shell.resolve(tArgs[1])
end

if not fs.isDir(sDir) then
    printError("Not a directory")
    return
end

-- Sort into dirs/files, and calculate column count
local tAll = fs.list(sDir)
local tFiles = {}
local tDirs = {}

local bShowHidden = settings.get("list.show_hidden")
for _, sItem in pairs(tAll) do
    if bShowHidden or string.sub(sItem, 1, 1) ~= "." then
        local sPath = fs.combine(sDir, sItem)
        if fs.isDir(sPath) then
            table.insert(tDirs, sItem)
        else
            table.insert(tFiles, sItem)
        end
    end
end
table.sort(tDirs)
table.sort(tFiles)

if term.isColour() then
    textutils.pagedTabulate(colors.blue, tDirs, colors.white, tFiles)
else
    textutils.pagedTabulate(colors.lightGray, tDirs, colors.white, tFiles)
end
