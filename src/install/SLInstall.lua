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
local pullEvent = os.pullEvent
local txt = textutils
os.pullEvent = os.pullEventRaw
local VER = "src"
local Copyright = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/"..VER.."/install/TOSPrint.txt")
local API = "https://api.github.com/repos/ASTRONAND/Starlight-OS/contents/"
local json = load(http.get("https://raw.githubusercontent.com/Starlight-CC/Starlight-OS/refs/heads/main/src/lib/sys/json.la").readAll())()
local textutils = load(http.get("https://raw.githubusercontent.com/Starlight-CC/Starlight-OS/refs/heads/main/src/lib/apis/textutils.la").readAll())()
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
    ["sbin/SLInstall.lua"] = true
  }
  
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
        textutils = text
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
        textutils = text
        fs.delete("sbin/SLInstall.lua")
        error("Install terminated",0)
    else
    end
end
term.setTextColor(colors.purple)
print("cleaming drive")
deleteFiles("/",exceptions)
term.setTextColor(colors.white)
print("Installing")
getFolder(API,VER.."/root/")
term.setTextColor(colors.gray)
print("Rebboting ...")
sleep(1)
term.setTextColor(colors.green)
print("SL.reboot service started")
shell.run("sys/serv/reboot.lua")