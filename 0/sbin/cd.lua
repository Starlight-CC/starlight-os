-- SPDX-FileCopyrightText: 2017 Daniel Ratcliffe
--
-- SPDX-License-Identifier: LicenseRef-CCPL
username = "Astronand"
local tArgs = { ... }
if #tArgs < 1 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. " <path>")
    print("shortcuts:")
    print("    ~ = user's home dir")
    print("    .. = previous dir")
    return
end

local sNewDir = shell.resolve(tArgs[1])
if tArgs[1] == "~" then
    shell.setDir("/home/"..username)
elseif fs.isDir(sNewDir) then
    shell.setDir(sNewDir)
else
    term.setTextColor(colors.red)
    print("Not a directory")
    term.setTextColor(colors.white)
    return
end
