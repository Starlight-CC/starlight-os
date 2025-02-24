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
term.setPaletteColor(colors.red,0xff0000)
term.setPaletteColor(colors.green,0x00ff00)
term.setPaletteColor(colors.blue,0x0000ff)
local pullEvent = os.pullEvent

local pgk_env = setmetatable({}, { __index = _ENV })
pgk_env.require = dofile("rom/modules/main/cc/require.lua").make(pgk_env, "rom/modules/main")
local require = pgk_env.require
_G.require = require
local VER = "src"
local API = "https://api.github.com/repos/Starlight-CC/Starlight-OS/contents/"
local json = load(http.get("https://raw.githubusercontent.com/Starlight-CC/Starlight-OS/refs/heads/main/tools/SLC/json.la").readAll())()
local PrimeUI = load(http.get("https://raw.githubusercontent.com/Starlight-CC/Starlight-OS/refs/heads/main/tools/SLC/install/PrimeUI.la").readAll())()

function err(s)
    term.blit("[ ERR ] ","77eee777","bbbbbbbb")
    print(s)
end
function info(s)
    term.blit("[ INFO ] ","771111777","bbbbbbbbb")
    print(s)
end
function ok(s)
    term.blit("[ OK ] ","7755777","bbbbbbb")
    print(s)
end

