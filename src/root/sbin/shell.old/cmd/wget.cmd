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
local function printUsage()
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage:")
    print("wget <url> [filename]")
    print("wget run <url>")
end

local tArgs = { ... }

local run = false
if tArgs[1] == "run" then
    table.remove(tArgs, 1)
    run = true
end

if #tArgs < 1 then
    printUsage()
    return
end

local url = table.remove(tArgs, 1)

if not http then
    printError("wget requires the http API, but it is not enabled")
    printError("Set http.enabled to true in CC: Tweaked's server config")
    return
end

local function getFilename(sUrl)
    sUrl = sUrl:gsub("[#?].*" , ""):gsub("/+$" , "")
    return sUrl:match("/([^/]+)$")
end

local function get(sUrl)
    -- Check if the URL is valid
    local ok, err = http.checkURL(url)
    if not ok then
        printError(err or "Invalid URL.")
        return
    end

    write("Connecting to " .. sUrl .. "... ")

    local response = http.get(sUrl)
    if not response then
        print("Failed.")
        return nil
    end

    print("Success.")

    local sResponse = response.readAll()
    response.close()
    return sResponse or ""
end

if run then
    local res = get(url)
    if not res then return end

    local func, err = load(res, getFilename(url), "t", _ENV)
    if not func then
        printError(err)
        return
    end

    local ok, err = pcall(func, table.unpack(tArgs))
    if not ok then
        printError(err)
    end
else
    local sFile = tArgs[1] or getFilename(url) or url
    local sPath = shell.resolve(sFile)
    if fs.exists(sPath) then
        print("File already exists")
        return
    end

    local res = get(url)
    if not res then return end

    local file, err = fs.open(sPath, "wb")
    if not file then
        printError("Cannot save file: " .. err)
        return
    end

    file.write(res)
    file.close()

    print("Downloaded as " .. sFile)
end
