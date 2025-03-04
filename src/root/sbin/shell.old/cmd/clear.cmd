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

local function printUsage()
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usages:")
    print(programName)
    print(programName .. " screen")
    print(programName .. " palette")
    print(programName .. " all")
end

local function clear()
    term.clear()
    term.setCursorPos(1, 1)
end

local function resetPalette()
    for i =  0, 15 do
        term.setPaletteColour(math.pow(2, i), term.nativePaletteColour(math.pow(2, i)))
    end
end

local sCommand = tArgs[1] or "screen"
if sCommand == "screen" then
    clear()
elseif sCommand == "palette" then
    resetPalette()
elseif sCommand == "all" then
    clear()
    resetPalette()
else
    printUsage()
end
