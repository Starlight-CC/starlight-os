local pullEvent = os.pullEvent
os.pullEvent = os.pullEventRaw
local Copyright = [[
Starlight OS
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
>>>

]]
local API = "https://api.github.com/repos/ASTRONAND/Starlight-OS/contents/src/root/"
term.setTextColor(colors.cyan)
print("Installing")
term.setTextColor(colors.white)
print("Connecting to "..API)
sleep(1.5)
term.clear()
term.setCursorPos(1,1)
textutils.pagedPrint(Copyright)
print("Y/N")
while true do
    local _,k,_ = os.pullEvent("key")
    if k == keys.y then
        break
    elseif k == keys.n then
        os.pullEvent = pullEvent
        error("Install terminated",0)
    else
    end
end
print("installing")

