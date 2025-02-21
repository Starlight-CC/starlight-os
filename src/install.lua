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
os.pullEvent = os.pullEventRaw
term.setPaletteColor(colors.red,0xff0000)
term.setPaletteColor(colors.green,0x00ff00)
term.setPaletteColor(colors.blue,0x0000ff)
term.clear()
term.setCursorPos(1,1)
term.write("Welcome to")
term.setTextColor(colors.blue)
term.write(" Starlight OS")
print("")
print("")
term.setTextColor(colors.cyan)
print("Updating Installer")
print("")
local file = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/src/install/SLInstall.lua")
local fh = fs.open("sbin/SLInstall.lua", "w")
fh.write(file.readAll())
fh.close()
sleep(1)
term.setTextColor(colors.green)
print("SL.install service started")
shell.run("sbin/SLInstall.lua")
