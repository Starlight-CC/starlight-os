
local w,h = term.getSize()
 
function printCentered( y,s )
    local x = math.floor((w - string.len(s)) / 2)
    term.setCursorPos(x,y)
    term.clearLine()
    term.write( s )
end
 
local nOption = 1
 
local function drawMenu()
    term.clear()
    term.setCursorPos(1,1)
    term.write("STARLIGHT BIOS // ")
    term.setCursorPos(1,2)
    term.write(os.getComputerID())
    term.setCursorPos(1,h)
    if nOption == 1 then
        term.write("Update OS")
    elseif nOption == 2 then
        term.write("Install a specific version")
    elseif nOption == 3 then
        term.write("Uninstall")
    elseif nOption == 4 then
        term.write("Configure OS")
    elseif nOption == 5 then
        term.write("Boots a OS")
    elseif nOption == 6 then
        term.write("Opens Craft OS Shell")
    elseif nOption == 7 then
        term.write("Turns off computer")
    else
    end
end
 
--GUI
term.clear()
local function drawFrontend()
    printCentered(math.floor(h/2) - 3, "")
    printCentered(math.floor(h/2) - 2, "STARLIGHT BIOS" )
    printCentered(math.floor(h/2) - 1, "")
    printCentered(math.floor(h/2) + 0, ((nOption == 1) and "[  Update      ]") or "Update       ")
    printCentered(math.floor(h/2) + 1, ((nOption == 2) and "[  Install ver ]") or "Install ver  ")
    printCentered(math.floor(h/2) + 2, ((nOption == 3) and "[  Uninstall   ]") or "Uninstall    ")
    printCentered(math.floor(h/2) + 3, ((nOption == 4) and "[  Config      ]") or "Config       ")
    printCentered(math.floor(h/2) + 4, ((nOption == 5) and "[  Boot        ]") or "Boot         ")
    printCentered(math.floor(h/2) + 5, ((nOption == 6) and "[  Shell       ]") or "Shell        ")
    printCentered(math.floor(h/2) + 6, ((nOption == 7) and "[  Shutdown    ]") or "Shutdown     ")
    printCentered(math.floor(h/2) + 7, "")
end

--Display
drawMenu()
drawFrontend()
 
while true do
    local e,p = os.pullEvent()
    w,h = term.getSize()
    if e == "key" then
        local key = p
        if key == 265 or key == 200 then
 
            if nOption > 1 then
                nOption = nOption - 1
                drawMenu()
                drawFrontend()
            end
        elseif key == 264 or key == 208 then
            if nOption < 7 then
                nOption = nOption + 1
                drawMenu()
                drawFrontend()
            end
        elseif key == 257 or key == 28 then
            --when enter pressed
        break
        end
    end
end
term.clear()
 
--Conditions
if nOption  == 1 then
    shell.run("STARLIGHTOS/Sys/Update")
elseif nOption == 2 then
    shell.run("STARLIGHTOS/Sys/Uninstall")
elseif nOption == 3 then
    shell.run("STARLIGHTOS/Sys/Install")
elseif nOption == 4 then
    shell.run("STARLIGHTOS/Sys/Config")
elseif nOption == 5 then
    shell.run("STARLIGHTOS/Sys/OSboot")
elseif nOption == 6 then
    term.setCursorPos(1,1)
    shell.run("rom/programs/shell.lua")
else
    os.shutdown()
end
