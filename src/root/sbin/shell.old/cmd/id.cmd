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
local sDrive = nil
local tArgs = { ... }
if #tArgs > 0 then
    sDrive = tostring(tArgs[1])
end

if sDrive == nil then
    print("This is computer #" .. os.getComputerID())

    local label = os.getComputerLabel()
    if label then
        print("This computer is labelled \"" .. label .. "\"")
    end

else
    if disk.hasAudio(sDrive) then
        local title = disk.getAudioTitle(sDrive)
        if title then
            print("Has audio track \"" .. title .. "\"")
        else
            print("Has untitled audio")
        end
        return
    end

    if not disk.hasData(sDrive) then
        print("No disk in drive " .. sDrive)
        return
    end

    local id = disk.getID(sDrive)
    if id then
        print("The disk is #" .. id)
    else
        print("Non-disk data source")
    end

    local label = disk.getLabel(sDrive)
    if label then
        print("Labelled \"" .. label .. "\"")
    end
end
