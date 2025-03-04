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
require "completion"

print("Drop files to transfer them to this computer")

local files
while true do
    local event, arg = os.pullEvent()
    if event == "file_transfer" then
        files = arg.getFiles()
        break
    elseif event == "key" and arg == keys.q then
        return
    end
end

if #files == 0 then
  printError("No files to transfer")
  return
end

local ok, err = require("internal.import")(files)
if not ok and err then printError(err) end
