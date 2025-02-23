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
os.util = {}
os._auth = {}
local expect = dofile("sys/modules/expect.la")
local expect, field = expect.expect, expect.field
function os.version()
    return "SLK 1.0.0"
end

function os.pullEventRaw( sFilter )
    return coroutine.yield( sFilter )
end

function os.pullEvent( sFilter )
    local eventData = table.pack( os.pullEventRaw( sFilter ) )
    if eventData[1] == "terminate" then
        error( "Terminated", 0 )
    end
    return table.unpack( eventData, 1, eventData.n )
end

loadfile = function( _sFile, _tEnv )
    if type( _sFile ) ~= "string" then
        error( "bad argument #1 (expected string, got " .. type( _sFile ) .. ")", 2 ) 
    end
    if _tEnv ~= nil and type( _tEnv ) ~= "table" then
        error( "bad argument #2 (expected table, got " .. type( _tEnv ) .. ")", 2 ) 
    end
    local file = fs.open( _sFile, "r" )
    if file then
        local func, err = load( file.readAll(), fs.getName( _sFile ), "t", _tEnv )
        file.close()
        return func, err
    end
    return nil, "File not found"
end

dofile = function( _sFile )
    if type( _sFile ) ~= "string" then
        error( "bad argument #1 (expected string, got " .. type( _sFile ) .. ")", 2 ) 
    end
    local fnFile, e = loadfile( _sFile, _G )
    if fnFile then
        return fnFile()
    else
        error( e, 2 )
    end
end

local nativeShutdown = os.shutdown
function os.shutdown()
    nativeShutdown()
    while true do
        coroutine.yield()
    end
end

local nativeReboot = os.reboot
function os.reboot()
    nativeReboot()
    while true do
        coroutine.yield()
    end
end

function os.username(e)
  if user == nil then
    user = e
    return true
  else
    return user
  end
end
os.username("root")

function os.hostname(e)
  if host == nil then
    host = e
    return true
  else
    return host
  end
end
os.hostname("CC")

function os.getUsers()
  file = fs.open("/.users","r")
  local e = file.readAll()
  file.close()
  return e 
end

function os.home(e)
    if os.username() == nil then
        return "root"
    end
    if e == nil then
        if os.username() == "root" then
            return "root"
        else
            return "home/"..os.username()
        end
    else
        if e == "root" then
            return "root"
        else
            return "home/"..e
        end
    end
end

function os.util.subHome(e)
    local ret = ""
    local idk = string.sub(e,1,#os.home())
    if idk == os.home() then
        local so = string.sub(e,#os.home()+1)
        ret = "~"..so
    else
        ret = "/"..e
    end
    return ret
end

function os._auth.verify(e)
end

function os._auth.set(e)
end

function os._auth.checkFilePerms(e)
end

function os.help(e)
    if e == nil then
        print("The OS API is how programs")
        print("interface with the kernel.")
        print("anything with a '_' at the start")
        print("of the function is only meant to")
        print("be used by the os. if a program")
        print("uses them it will be terminated.")
    else
        if fs.exists("/sys/help/"..e..".txt") then
            local File = fs.open("/sys/help/"..e..".txt", "rb")
            print(File.readAll())
            File.close()
        else
            term.setTextColor(colors.red)
            print("No help file found")
        end
    end
end

function fs.complete(sPath, sLocation, bIncludeFiles, bIncludeDirs)
    expect(1, sPath, "string")
    expect(2, sLocation, "string")
    local bIncludeHidden = nil
    if type(bIncludeFiles) == "table" then
        bIncludeDirs = field(bIncludeFiles, "include_dirs", "boolean", "nil")
        bIncludeHidden = field(bIncludeFiles, "include_hidden", "boolean", "nil")
        bIncludeFiles = field(bIncludeFiles, "include_files", "boolean", "nil")
    else
        expect(3, bIncludeFiles, "boolean", "nil")
        expect(4, bIncludeDirs, "boolean", "nil")
    end

    bIncludeHidden = bIncludeHidden ~= false
    bIncludeFiles = bIncludeFiles ~= false
    bIncludeDirs = bIncludeDirs ~= false
    local sDir = sLocation
    local nStart = 1
    local nSlash = string.find(sPath, "[/\\]", nStart)
    if nSlash == 1 then
        sDir = ""
        nStart = 2
    end
    local sName
    while not sName do
        local nSlash = string.find(sPath, "[/\\]", nStart)
        if nSlash then
            local sPart = string.sub(sPath, nStart, nSlash - 1)
            sDir = fs.combine(sDir, sPart)
            nStart = nSlash + 1
        else
            sName = string.sub(sPath, nStart)
        end
    end

    if fs.isDir(sDir) then
        local tResults = {}
        if bIncludeDirs and sPath == "" then
            table.insert(tResults, ".")
        end
        if sDir ~= "" then
            if sPath == "" then
                table.insert(tResults, bIncludeDirs and ".." or "../")
            elseif sPath == "." then
                table.insert(tResults, bIncludeDirs and "." or "./")
            end
        end
        local tFiles = fs.list(sDir)
        for n = 1, #tFiles do
            local sFile = tFiles[n]
            if #sFile >= #sName and string.sub(sFile, 1, #sName) == sName and (
                bIncludeHidden or sFile:sub(1, 1) ~= "." or sName:sub(1, 1) == "."
            ) then
                local bIsDir = fs.isDir(fs.combine(sDir, sFile))
                local sResult = string.sub(sFile, #sName + 1)
                if bIsDir then
                    table.insert(tResults, sResult .. "/")
                    if bIncludeDirs and #sResult > 0 then
                        table.insert(tResults, sResult)
                    end
                else
                    if bIncludeFiles and #sResult > 0 then
                        table.insert(tResults, sResult)
                    end
                end
            end
        end
        return tResults
    end

    return {}
end

function os.about()
    if fs.exists("/sys/about.txt") then
        file = fs.open("/sys/about.txt","r")
        local e = file.readAll
        file.close()
        return e
    else
        return "file not found"
    end
end

function os.run(_tEnv, _sPath, ...)
    expect(1, _tEnv, "table")
    expect(2, _sPath, "string")

    local tEnv = _tEnv
    setmetatable(tEnv, { __index = _G })

    if settings.get("bios.strict_globals", false) then
        -- load will attempt to set _ENV on this environment, which
        -- throws an error with this protection enabled. Thus we set it here first.
        tEnv._ENV = tEnv
        getmetatable(tEnv).__newindex = function(_, name)
          error("Attempt to create global " .. tostring(name), 2)
        end
    end

    local fnFile, err = loadfile(_sPath, nil, tEnv)
    if fnFile then
        local ok, err = pcall(fnFile, ...)
        if not ok then
            if err and err ~= "" then
                printError(err)
            end
            return false
        end
        return true
    end
    if err and err ~= "" then
        printError(err)
    end
    return false
end

local tAPIsLoading = {}
function os.loadAPI(_sPath)
    local sName = fs.getName(_sPath)
    if sName:sub(-4) == ".lua" then
        sName = sName:sub(1, -5)
    end
    if tAPIsLoading[sName] == true then
        printError("API " .. sName .. " is already being loaded")
        return false
    end
    tAPIsLoading[sName] = true

    local tEnv = {}
    setmetatable(tEnv, { __index = _G })
    if type(_sPath) == "string" then
        local fnAPI, err = loadfile(_sPath, nil, tEnv)
    elseif type(_sPath) == "function" then
        local fnAPI = _sPath
    end
    if fnAPI then
        local ok, err = pcall(fnAPI)
        if not ok then
            tAPIsLoading[sName] = nil
            return error("Failed to load API " .. sName .. " due to " .. err, 1)
        end
    else
        tAPIsLoading[sName] = nil
        return error("Failed to load API " .. sName .. " due to " .. err, 1)
    end

    local tAPI = {}
    for k, v in pairs(tEnv) do
        if k ~= "_ENV" then
            tAPI[k] =  v
        end
    end

    _G[sName] = tAPI
    tAPIsLoading[sName] = nil
    return true
end

function os.unloadAPI(_sName)
    expect(1, _sName, "string")
    if _sName ~= "_G" and type(_G[_sName]) == "table" then
        _G[_sName] = nil
    end
end

-- Load APIs
local bAPIError = false
local tApis = fs.list("/lib/apis")
for n,sFile in ipairs( tApis ) do
    if string.sub( sFile, 1, 1 ) ~= "." then
        local sPath = fs.combine( "/lib/apis", sFile )
        if not fs.isDir( sPath ) then
            if not os.loadAPI( sPath ) then
                bAPIError = true
            end
        end
    end
end

if pocket and fs.isDir( "/lib/apis/pocket" ) then
    -- Load pocket APIs
    local tApis = fs.list( "/lib/apis/pocket" )
    for n,sFile in ipairs( tApis ) do
        if string.sub( sFile, 1, 1 ) ~= "." then
            local sPath = fs.combine( "/lib/apis/pocket", sFile )
            if not fs.isDir( sPath ) then
                if not os.loadAPI( sPath ) then
                    bAPIError = true
                end
            end
        end
    end
end

if bAPIError then
    print( "Press any key to continue" )
    os.pullEvent( "key" )
    term.clear()
    term.setCursorPos( 1,1 )
end

-- Load user settings
if fs.exists( ".settings" ) then
    settings.load( ".settings" )
end

-- Run the OS
local ok, err = pcall( function()
    parallel.waitForAny( 
        function()
            if term.isColour() then
                os.run({}, "/sbin/shell/shell.lua")
            else
                printError("Use advanced computer...")
                sleep(3)
                term.setTextColor(colors.green)
                print("SL.shutdownService")
                os.run({},"/sys/serv/shutdown.lua")
            end
            print( "Internal error" )
            print( "Press any key to continue" )
            os.pullEvent( "key" )
            term.setTextColor(colors.green)
            print("SL.shutdownService")
            os.run( {}, "/sys/serv/shutdown.lua" )
        end,
        function()
            while true do
                sleep(1)
            end
        end 
    )
    
end )

-- If the OS errored, let the user read it.
term.redirect( term.native() )
if not ok then
    printError( err )
    pcall( function()
        term.setCursorBlink( false )
        print( "Press any key to continue" )
        os.pullEvent( "key" )
    end )
end

-- End
os.shutdown()
