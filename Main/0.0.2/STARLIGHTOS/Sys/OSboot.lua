dofile("/STARLIGHTOS/Data/COS.db")

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
end
local c1 = 1
local total = 1
local list ={
    "STARLIGHT/Sys/Startup.lua"
}
--GUI
term.clear()
local function drawFrontend()
    printCentered(math.floor(h/2) - 3, "")
    printCentered(math.floor(h/2) - 2, "Boot Menu" )
    printCentered(math.floor(h/2) - 1, "")
    printCentered(math.floor(h/2) + 0, ((nOption == 1) and "[  STARLIGHT   ]") or "STARLIGHT    ")
    for i,v in ipairs(COS) do
        if fs.exists(v) then
            printCentered(math.floor(h/2) + c1, ((nOption == c1+1) and "[  " .. v .. "]") or v )
            table.insert(list,c1+1,v)
            c1 = c1 + 1
        end
    end
    total = c1
    printCentered(math.floor(h/2) + c1, "")
    c1 = 1
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
            if nOption < total then
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
shell.run(list[nOption])