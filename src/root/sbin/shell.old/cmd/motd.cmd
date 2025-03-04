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
local date = os.date("*t")
if date.month == 1 and date.day == 1 then
    print("Happy new year!")
elseif date.month == 12 and date.day == 24 then
    print("Merry X-mas!")
elseif date.month == 10 and date.day == 31 then
    print("OOoooOOOoooo! Spooky!")
elseif date.month == 4 and date.day == 28 then
    print("Ed Balls")
else
    local tMotd = {}

    for sPath in string.gmatch(settings.get("motd.path"), "[^:]+") do
        if fs.exists(sPath) then
            for sLine in io.lines(sPath) do
                table.insert(tMotd, sLine)
            end
        end
    end

    if #tMotd == 0 then
        print("missingno")
    else
        print(tMotd[math.random(1, #tMotd)])
    end
end
