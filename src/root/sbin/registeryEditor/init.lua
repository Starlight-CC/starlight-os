local tArgs = {...}
local PrimeUI = dofile("/lib/PrimeUI.la")
PrimeUI.clear()
local x,y = term.getSize()
PrimeUI.borderBox(term.current(),2,y-2,x-2,2, colors.white, colors.blue)
PrimeUI.label(term.current(),2,y-2,"Do you want to compile with this copyright?"..string.rep(" ",x-45), colors.white, colors.blue)
PrimeUI.label(term.current(),2,y-1,"Yes = Y | No = N"..string.rep(" ",x-18), colors.white, colors.blue)
local scroller = PrimeUI.scrollBox(term.current(), 1, 1, x, y-4, 9000, true, true, colors.white, colors.blue)
PrimeUI.drawText(scroller, Copyright, true, colors.white, colors.blue)
PrimeUI.keyAction(keys.y, "done")
PrimeUI.keyAction(keys.n, "Terminate")
local _,ac = PrimeUI.run()
if ac == "Terminate" then
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(1,1)
    os.pullEvent = pullEvent
    error("Compile terminated",0)
end