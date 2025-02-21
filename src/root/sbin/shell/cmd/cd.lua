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
if #tArgs < 1 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. " <path>")
    print("shortcuts:")
    print("    ~ = user's home dir")
    print("    .. = previous dir")
    print("    / = root dir")
    return
end

local sNewDir = shell.resolve(tArgs[1])
if string.sub(tArgs[1],1,1) == "~" then
    if os.username() == "root" then
        shell.setDir("/root/"..string.sub(tArgs[1],2))
    else
        shell.setDir("/home/"..os.username()..string.sub(tArgs[1],2))
    end
elseif fs.isDir(sNewDir) then
    shell.setDir(sNewDir)
else
    term.setTextColor(colors.red)
    print("Not a directory")
    term.setTextColor(colors.white)
    return
end
