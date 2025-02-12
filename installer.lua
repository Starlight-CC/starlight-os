local w,h = term.getSize()
 
function printCentered( y,s )
    local x = math.floor((w - string.len(s)) / 2)
    term.setCursorPos(x,y)
    term.clearLine()
    term.write( s )
end
local table = {
    {
        "Install latest",
        "Install ver   ",
        "Configure     ",
        "Exit          "
    },
    {
        "Installs latest",
        "Install version of choice",
        "Configure OS",
        "Exit to shell"
    }
}
local nOption = 1
local it = 1
 
local function drawMenu(t)
    term.clear()
    term.setCursorPos(1,1)
    term.write("STARLIGHT INSTALLER // ")
    term.setCursorPos(1,2)
    term.write(os.getComputerID())
    term.setCursorPos(1,h)
    for i,v in ipairs(t[2]) do
        if nOption == i then
            term.write(v)
        end
    end
end
 
--GUI
term.clear()
local function drawFrontend(t)
    printCentered(math.floor(h/2) - 3, "")
    printCentered(math.floor(h/2) - 2, "STARLIGHT BIOS" )
    printCentered(math.floor(h/2) - 1, "")
    for i,v in ipairs(t[1]) do
        printCentered(math.floor(h/2) + i-1, ((nOption == i) and "[  "..v.."]") or v)
        it = it + 1
    end
    printCentered(math.floor(h/2) + it, "")
end

--Display
drawMenu(table)
drawFrontend(table)

local function Menu(t)
    while true do
        local e,p = os.pullEvent()
        w,h = term.getSize()
        if e == "key" then
            local key = p
            if key == keys.up then
    
                if nOption > 1 then
                    nOption = nOption - 1
                    drawMenu(1)
                    drawFrontend(table)
                end
            elseif key == keys.down then
                if nOption < #table+1 then
                    nOption = nOption + 1
                    drawMenu(table)
                    drawFrontend(table)
                end
            elseif key == keys.enter then
                --when enter pressed
            break
            end
        end
    end
end
term.clear()
 
--Conditions
if nOption  == 1 then
    
elseif nOption == 2 then
    
elseif nOption == 3 then
    
else
    os.shutdown()
end