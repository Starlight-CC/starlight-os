local tArgs = {...}
local PrimeUI = dofile("/lib/PrimeUI.la")
PrimeUI.clear()
local w,h = term.getSize()
PrimeUI.borderBox(term.current(),2,h-2,w-2,2, colors.white, colors.blue)
PrimeUI.run()