--[[
Made for use in StarlightOS
filed under GNU General Public License.
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
    print("Usage: [arg] <string>")
    print("Usage: <string>")
    return
end

if string.sub(tArgs[1],#tArgs[1]-2) == ".sh" then
  local file = fs.open(tArgs[1],"r")
  local text = ""
  while true do
    text = file.readLine(true)
    if text == "end" then
      break
    else
      shell.run(text)
    end
  end
else
  shell.run(tArgs[1])
end