-- Config for OS

local w,h = term.getSize()
 
function printCentered( y,s )
    local x = math.floor((w - string.len(s)) / 2)
    term.setCursorPos(x,y)
    term.clearLine()
    term.write( s )
end



local diskStart = settings.get("enable_disk_startup")

if diskStart == nill then
    settings.set("enable_disk_startup", false)
    settings.save()
    diskStart = settings.get("enable_disk_startup")
end
local nOption = 1
 
local function drawMenu()
    term.clear()
    term.setCursorPos(1,1)
    term.write("STARLIGHT BIOS CONFIG // ")
    term.setCursorPos(1,2)
    term.write(os.getComputerID())
    term.setCursorPos(1,h)
    if nOption == 1 then
        term.write("Select Boot Order")
    elseif nOption == 2 then
        term.write(diskStart .. " disk start")
    elseif nOption == 3 then
        term.write("Uninstall")
    elseif nOption == 4 then
        term.write("Configure OS")
    elseif nOption == 5 then
        term.write("Boots a OS")
    elseif nOption == 6 then
        term.write("Opens Craft OS Shell")
    elseif nOption == 7 then
        term.write("Exit")
    else
    end
end
 
--GUI
term.clear()
local function drawFrontend()
    printCentered(math.floor(h/2) - 3, "")
    printCentered(math.floor(h/2) - 2, "STARLIGHT BIOS Config" )
    printCentered(math.floor(h/2) - 1, "")
    printCentered(math.floor(h/2) + 0, ((nOption == 1) and "[  Boot Order      ]") or "Boot Order       ")
    printCentered(math.floor(h/2) + 1, ((nOption == 2) and "[  Disk start      ]") or "Disk start       ")
    printCentered(math.floor(h/2) + 2, ((nOption == 3) and "[  Uninstall   ]") or "Uninstall    ")
    printCentered(math.floor(h/2) + 3, ((nOption == 4) and "[  Config      ]") or "Config       ")
    printCentered(math.floor(h/2) + 4, ((nOption == 5) and "[  Boot        ]") or "Boot         ")
    printCentered(math.floor(h/2) + 5, ((nOption == 6) and "[  Shell       ]") or "Shell        ")
    printCentered(math.floor(h/2) + 6, ((nOption == 7) and "[  Exit    ]") or "Exit     ")
    printCentered(math.floor(h/2) + 7, "")
end

--Display
drawMenu()
drawFrontend()


--Conditions
if nOption  == 1 then
    shell.run("clear all")
    local file2 = fs.open("STARLIGHTOS/Config/bootOrder.boot", "r")
    local bootO = file2.readAll()
    file2.close()
    printCentered(math.floor(h/2) + 2, "Boot order (0: disk, 1: Startup, 2: BIOS, 3: Shell)")
    local user = io.read()
    io.open("bootOrder.boot", "w")
    io.write(user)
    io.close()
elseif nOption == 2 then
    shell.run("clear all")
    printCentered(math.floor(h/2) + 0, diskStart)
    printCentered(math.floor(h/2) + 2, "true or false")
    local user = io.read()
    if user == "true" or user == "True" then
        settings.set("enable_disk_startup")
    else
       settings.set("enable_disk_startup") 
    end
    diskStart = settings.get("enable_disk_startup")
    
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
