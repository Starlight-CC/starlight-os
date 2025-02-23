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
local txt = textutils
os.pullEvent = os.pullEventRaw
local VER = "src"
local Copyright = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/"..VER.."/install/TOSPrint.txt")
local API = "https://api.github.com/repos/ASTRONAND/Starlight-OS/contents/"
local json = load(http.get("https://raw.githubusercontent.com/Starlight-CC/Starlight-OS/refs/heads/main/src/root/lib/sys/json.la").readAll())()

local pgk_env = setmetatable({}, { __index = _ENV })
pgk_env.require = dofile("rom/modules/main/cc/require.lua").make(pgk_env, "rom/modules/main")
local require = pgk_env.require

local expect = require("cc.expect")
local expect, field = expect.expect, expect.field
local wrap = require("cc.strings").wrap

function go(s)
    term.blit("[ DO ] ","77ee777","bbbbbbb")
    print(s)
end
function ok(s)
    term.blit("[ OK ] ","7755777","bbbbbbb")
    print(s)
end
function getFolder(a,dir)
    local con = json.decode(http.get(a..dir).readAll())
    for i,v in ipairs(con) do
        if v["type"] == "file" then
            go(string.sub(v["path"],#VER+7))
            local file = http.get(v["download_url"])
            local fh = fs.open(string.sub(v["path"],#VER+7), "w")
            fh.write(file.readAll())
            fh.close()
            ok(string.sub(v["path"],#VER+7))
        elseif v["type"] == "dir" then
            getFolder(API,v["path"])
        else
            error("Install ERROR",0)
        end
    end
end
local function deleteFiles(directory, exceptions)
    for _, entry in ipairs(fs.list(directory)) do
      local fullPath = fs.combine(directory, entry)
      if fs.isDir(fullPath) then
        if not exceptions[entry] then
          deleteFiles(fullPath, exceptions)
          fs.delete(fullPath) -- Delete the folder after deleting its contents
          print("Deleted "..fullPath)
        end
      elseif not exceptions[entry] then
        fs.delete(fullPath) -- Delete the file
        print("Deleted "..fullPath)
      end
    end
  end
  
  local exceptions = {
    ["rom"] = true,
    ["sbin/SLInstall.lua"] = true,
    ["sbin"] = true
  }

function write(sText)
    expect(1, sText, "string", "number")

    local w, h = term.getSize()
    local x, y = term.getCursorPos()

    local nLinesPrinted = 0
    local function newLine()
        if y + 1 <= h then
            term.setCursorPos(1, y + 1)
        else
            term.setCursorPos(1, h)
            term.scroll(1)
        end
        x, y = term.getCursorPos()
        nLinesPrinted = nLinesPrinted + 1
    end

    -- Print the line with proper word wrapping
    sText = tostring(sText)
    while #sText > 0 do
        local whitespace = string.match(sText, "^[ \t]+")
        if whitespace then
            -- Print whitespace
            term.write(whitespace)
            x, y = term.getCursorPos()
            sText = string.sub(sText, #whitespace + 1)
        end

        local newline = string.match(sText, "^\n")
        if newline then
            -- Print newlines
            newLine()
            sText = string.sub(sText, 2)
        end

        local text = string.match(sText, "^[^ \t\n]+")
        if text then
            sText = string.sub(sText, #text + 1)
            if #text > w then
                -- Print a multiline word
                while #text > 0 do
                    if x > w then
                        newLine()
                    end
		    s = term.write(text)
                    if s == true then
			break
		    end
                    text = string.sub(text, w - x + 2)
                    x, y = term.getCursorPos()
                end
            else
                -- Print a word normally
                if x + #text - 1 > w then
                    newLine()
                end
                s = term.write(text)
		if s == true then
			break
		    end
                x, y = term.getCursorPos()
            end
        end
    end

    return nLinesPrinted
end

function print(...)
    local nLinesPrinted = 0
    local nLimit = select("#", ...)
    for n = 1, nLimit do
        local s = tostring(select(n, ...))
        if n < nLimit then
            s = s .. "\t"
        end
        nLinesPrinted = nLinesPrinted + write(s)
    end
    nLinesPrinted = nLinesPrinted + write("\n")
    return nLinesPrinted
end

local function makePagedScrollS(_term, _nFreeLines)
    local nativeScroll = _term.scroll
    local nFreeLines = _nFreeLines or 0
    return function(_n)
        for _ = 1, _n do
            nativeScroll(1)
	    skip = false
            if nFreeLines <= 0 then
                local _, h = _term.getSize()
                _term.setCursorPos(1, h)
                _term.write("Press any key to continue, press s to skip, press q to quit")
                _,k = os.pullEvent("key") 
                if k == keys.s then
		    skip = true
                    break
                elseif k == keys.q then
		    term.setBackgroundColor(colors.black)
		    term.clear()
		    term.setCursorPos(1,1)
                    error("Install terminated",0)
		else
                end 
                _term.clearLine()
                _term.setCursorPos(1, h)
            else
                nFreeLines = nFreeLines - 1
            end
        end
    	return skip
    end
end

local function pagedPrintS(text, free_lines)
    expect(2, free_lines, "number", "nil")
    -- Setup a redirector
    local oldTerm = term.current()
    local newTerm = {}
    for k, v in pairs(oldTerm) do
        newTerm[k] = v
    end
    newTerm.scroll = makePagedScrollS(oldTerm, free_lines)
    term.redirect(newTerm)

    -- Print the text
    local result
    local ok, err = pcall(function()
        if text ~= nil then
            result = print(text)
        else
            result = print()
        end
    end)

    -- Removed the redirector
    term.redirect(oldTerm)

    -- Propogate errors
    if not ok then
        error(err, 0)
    end
    return result
end

function textutils.pagedPrintSkip(s)
    pagedPrintS(s)
end
term.setTextColor(colors.white)
print("Connecting to "..API)
sleep(1.5)
term.setBackgroundColor(colors.blue)
term.clear()
term.setCursorPos(1,1)
textutils.pagedPrintSkip(Copyright.readAll())
print("")
print("(Y/N)")
while true do
    local _,k,_ = os.pullEvent("key")
    if k == keys.y then
        break
    elseif k == keys.n then
        term.setBackgroundColor(colors.blue)
        term.clear()
        term.setCursorPos(1,1)
        os.pullEvent = pullEvent
        fs.delete("sbin/SLInstall.lua")
        error("Install terminated",0)
    else
    end
end
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.white)
print("This will delete EVERYTHING on / are you sure you want to install")
print("(Y/N)")
while true do
    local _,k,_ = os.pullEvent("key")
    if k == keys.y then
        break
    elseif k == keys.n then
        term.setBackgroundColor(colors.blue)
        term.clear()
        term.setCursorPos(1,1)
        os.pullEvent = pullEvent
        fs.delete("sbin/SLInstall.lua")
        error("Install terminated",0)
    else
    end
end
term.setTextColor(colors.purple)
print("cleaning drive")
deleteFiles("/",exceptions)
term.setTextColor(colors.white)
print("Installing")
getFolder(API,VER.."/root/")
term.setTextColor(colors.gray)
shell.run("tmp/shellSet.lua")
print("Rebooting ...")
sleep(1)
term.setTextColor(colors.green)
print("SL.reboot service started")
shell.run("sys/serv/reboot.lua")
