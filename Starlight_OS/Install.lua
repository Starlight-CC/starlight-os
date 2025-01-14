repoBase = 
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
        term.write("Install Starlight OS")
    elseif nOption == 2 then
        term.write("Exit to shell")
    else
    end
end
 
--GUI
term.clear()
local function drawFrontend()
    printCentered(math.floor(h/2) - 3, "")
    printCentered(math.floor(h/2) - 2, "Install STARLIGHT" )
    printCentered(math.floor(h/2) - 1, "")
    printCentered(math.floor(h/2) + 0, ((nOption == 1) and "[  Install     ]") or "Install      ")
    printCentered(math.floor(h/2) + 1, ((nOption == 2) and "[  Exit        ]") or "Exit         ")
    printCentered(math.floor(h/2) + 2, "")
end
 
--Display
drawMenu()
drawFrontend()
 
while true do
    local e,p = os.pullEvent()
    if e == "key" then
        local key = p
        if key == 265 or key == 200 then
 
            if nOption > 1 then
                nOption = nOption - 1
                drawMenu()
                drawFrontend()
            end
        elseif key == 264 or key == 208 then
            if nOption < 2 then
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
    
else
    shell.run("rom/programs/shell.lua")
end