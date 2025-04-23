local tArgs = {...}
local wpm = dofile("/sys/modules/sys/wpm.la")
if tArgs[1] == "host" then
    wpm.wireless.listen(tArgs[2])
end