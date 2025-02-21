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
local pp = require "pretty"

local tArgs = { ... }
if #tArgs == 0 then
    -- "set"
    local _, y = term.getCursorPos()
    local tSettings = {}
    for n, sName in ipairs(settings.getNames()) do
        tSettings[n] = textutils.serialize(sName) .. " is " .. textutils.serialize(settings.get(sName))
    end
    textutils.pagedPrint(table.concat(tSettings, "\n"), y - 3)

elseif #tArgs == 1 then
    -- "set foo"
    local sName = tArgs[1]
    local deets = settings.getDetails(sName)
    local msg = pp.text(sName, colors.cyan) .. " is " .. pp.pretty(deets.value)
    if deets.default ~= nil and deets.value ~= deets.default then
        msg = msg .. " (default is " .. pp.pretty(deets.default) .. ")"
    end
    pp.print(msg)
    if deets.description then print(deets.description) end

else
    -- "set foo bar"
    local sName = tArgs[1]
    local sValue = tArgs[2]
    local value
    if sValue == "true" then
        value = true
    elseif sValue == "false" then
        value = false
    elseif sValue == "nil" then
        value = nil
    elseif tonumber(sValue) then
        value = tonumber(sValue)
    else
        value = sValue
    end

    local option = settings.getDetails(sName)
    if value == nil then
        settings.unset(sName)
        print(textutils.serialize(sName) .. " unset")
    elseif option.type and option.type ~= type(value) then
        printError(("%s is not a valid %s."):format(textutils.serialize(sValue), option.type))
    else
        settings.set(sName, value)
        print(textutils.serialize(sName) .. " set to " .. textutils.serialize(value))
    end

    if value ~= option.value then
        settings.save()
    end
end
