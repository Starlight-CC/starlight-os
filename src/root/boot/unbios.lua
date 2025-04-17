-- Run the OS
local ok, err = pcall( function()
    parallel.waitForAny( 
        function()
            if term.isColour() then
                os.run({}, "/boot/SLKernel.sys")
            else
                printError("Sorry this OS is only for advanced computers")
                sleep(3)
                term.setTextColor(colors.green)
                print("SL.shutdownService")
                os.run({},"/sys/serv/shutdown.sys")
            end
            print( "Press any key to continue" )
            os.pullEvent( "key" )
            term.setTextColor(colors.green)
            print("SL.rebootService")
            os.run( {}, "/sys/serv/reboot.sys" )
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
