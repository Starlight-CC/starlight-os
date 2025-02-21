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

-- Get where a directory is mounted
local sPath = shell.dir()
if tArgs[1] ~= nil then
    sPath = shell.resolve(tArgs[1])
end

if fs.exists(sPath) then
    write(fs.getDrive(sPath) .. " (")
    local nSpace = fs.getFreeSpace(sPath)
    if nSpace >= 1000 * 1000 then
        print(math.floor(nSpace / (100 * 1000)) / 10 .. "MB remaining)")
    elseif nSpace >= 1000 then
        print(math.floor(nSpace / 100) / 10 .. "KB remaining)")
    else
        print(nSpace .. "B remaining)")
    end
else
    print("No such path")
end
