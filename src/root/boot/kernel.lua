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

-- Run the shell
local ok, err = pcall( function()
    parallel.waitForAny( 
        function()
            if term.isColour() then
                os.run({}, "/sbin/shell/shell.spr")
            else
                printError("Use advanced computer...")
                sleep(3)
                term.setTextColor(colors.green)
                print("SL.shutdownService")
                os.run({},"/sys/serv/shutdown.lua")
            end
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