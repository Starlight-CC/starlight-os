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
    local OSVERS1 = ""
    local OSVERS2 = ""
    local OSVERS3 = ""

    local function drawMenu2()
        term.clear()
        term.setCursorPos(1,1)
        term.write("STARLIGHT BIOS // ")
        term.setCursorPos(1,2)
        term.write(os.getComputerID())
        term.setCursorPos(1,h)
        term.write(OSVERS2)
    end
    
    --GUI
    term.clear()
    
    local file = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/OSver.db")
    local fh = fs.open("/temp/OSLst.db", "w")
    fh.write(file.readAll())
    fh.close()
    dofile("/temp/OSLst.db")
    
    nOption = 2
    local veramount = table.getn(OSL)-1
    local function updatevars()
        OSVERS1 = OSL[nOption-1]
        OSVERS2 = OSL[nOption]
        OSVERS3 = OSL[nOption+1]
    end

    local function drawFrontend2()
        printCentered(math.floor(h/2) - 3, "")
        printCentered(math.floor(h/2) - 2, "Install STARLIGHT" )
        printCentered(math.floor(h/2) - 1, "")
        printCentered(math.floor(h/2) + 0, ((nOption == nOption-1) and "[ "..OSVERS1.."]") or OSVERS1)
        printCentered(math.floor(h/2) + 1, ((nOption == nOption) and "[ "..OSVERS2.."]") or OSVERS2)
        printCentered(math.floor(h/2) + 2, ((nOption == nOption+1) and "[ "..OSVERS3.."]") or OSVERS3)
        printCentered(math.floor(h/2) + 3, "")
    end
     
    --Display
    updatevars()
    drawMenu2()
    drawFrontend2()
    
    
    while true do
        local e,p = os.pullEvent()
        if e == "key" then
            local key = p
            if key == 265 or key == 200 then
     
                if nOption > 2 then
                    nOption = nOption - 1
                    updatevars()
                    drawMenu2()
                    drawFrontend2()
                end
            elseif key == 264 or key == 208 then
                if nOption < veramount then
                    nOption = nOption + 1
                    updatevars()
                    drawMenu2()
                    drawFrontend2()
                end
            elseif key == 257 or key == 28 then
                --when enter pressed
            break
            end
        end
    end
    term.clear()
    
    local file = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/OSurl.db")
    local fh = fs.open("/temp/OSurl.db", "w")
    fh.write(file.readAll())
    fh.close()
    dofile("/temp/OSurl.db")

    local file = http.get(verurl[nOption])
    local fh = fs.open("/temp/OSR.db", "w")
    fh.write(file.readAll())
    fh.close()
    dofile("/temp/OSR.db")

    local file = http.get(OSR[1])
    local fh = fs.open("/temp/OSN.db", "w")
    fh.write(file.readAll())
    fh.close()
    dofile("/temp/OSN.db")

    local file = http.get(OSR[2])
    local fh = fs.open("/temp/OSL.db", "w")
    fh.write(file.readAll())
    fh.close()
    dofile("/temp/OSL.db")

    term.clear()
    term.setCursorPos(1,1)
    for i,v in ipairs(OSF) do
        local file = http.get(v)
        local fh = fs.open(OSN[i], "w")
        fh.write(file.readAll())
        fh.close()
        print("[OK] "..OSN[i].." Installed and ready")
    end
else
    shell.run("rom/programs/shell.lua")
end