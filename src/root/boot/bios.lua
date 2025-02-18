os.util = {}
os._auth = {}
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

function printError( ... )
    local oldColour
    if term.isColor() then
        oldColour = term.getTextColor()
        term.setTextColor( colors.red )
    end
    print( ... )
    if term.isColor() then
        term.setTextColor( oldColour )
    end
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

function os.run( _tEnv, _sPath, ... )
    if type( _tEnv ) ~= "table" then
        error( "bad argument #1 (expected table, got " .. type( _tEnv ) .. ")", 2 ) 
    end
    if type( _sPath ) ~= "string" then
        error( "bad argument #2 (expected string, got " .. type( _sPath ) .. ")", 2 ) 
    end
    local tArgs = table.pack( ... )
    local tEnv = _tEnv
    setmetatable( tEnv, { __index = _G } )
    local fnFile, err = loadfile( _sPath, tEnv )
    if fnFile then
        local ok, err = pcall( function()
            fnFile( table.unpack( tArgs, 1, tArgs.n ) )
        end )
        if not ok then
            if err and err ~= "" then
                printError( err )
            end
            return false
        end
        return true
    end
    if err and err ~= "" then
        printError( err )
    end
    return false
end

local tAPIsLoading = {}
function os.loadAPI( _sPath )
    if type( _sPath ) ~= "string" then
        error( "bad argument #1 (expected string, got " .. type( _sPath ) .. ")", 2 ) 
    end
    local sName = fs.getName( _sPath )
    if sName:sub(-4) == ".lua" then
        sName = sName:sub(1,-5)
    end
    if tAPIsLoading[sName] == true then
        printError( "API "..sName.." is already being loaded" )
        return false
    end
    tAPIsLoading[sName] = true

    local tEnv = {}
    setmetatable( tEnv, { __index = _G } )
    local fnAPI, err = loadfile( _sPath, tEnv )
    if fnAPI then
        local ok, err = pcall( fnAPI )
        if not ok then
            printError( err )
            tAPIsLoading[sName] = nil
            return false
        end
    else
        printError( err )
        tAPIsLoading[sName] = nil
        return false
    end
    
    local tAPI = {}
    for k,v in pairs( tEnv ) do
        if k ~= "_ENV" then
            tAPI[k] =  v
        end
    end

    _G[sName] = tAPI    
    tAPIsLoading[sName] = nil
    return true
end

function os.unloadAPI( _sName )
    if type( _sName ) ~= "string" then
        error( "bad argument #1 (expected string, got " .. type( _sName ) .. ")", 2 ) 
    end
    if _sName ~= "_G" and type(_G[_sName]) == "table" then
        _G[_sName] = nil
    end
end

function os.sleep( nTime )
    sleep( nTime )
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
  if user == nil and not e == nil then
    user = e
    return true
  else
    return user
  end
end

function os.hostname(e)
  if host == nil and not e == nil then
    host = e
    return true
  else
    return host
  end
end

function os.getUsers()
  file = fs.open("/.users","r")
  local e = file.readAll()
  file.close()
  return e 
end

function os.home(e)
    if e == nil then
        if os.username() == "root" then
            return "root/"
        else
            return "home/"..os.username()
        end
    else
        if e == "root" then
            return "root/"
        else
            return "home/"..e
        end
    end
end

function os.util.subHome(e)
    local ret
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
        if fs.exists("sys/help/"..e..".txt")
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