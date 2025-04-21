--Copyright (C) 2025  Starlight-CC
sleep(0)
term.clear()
local w,h = term.getSize()
local function printCentered(h,string)
    term.setCursorPos((w/2)-(#string/2),h)
    term.write(string)
end
printCentered(h-2,"Press ctrl+1 to enter boot menu")
term.setTextColor(colors.cyan)
local id = os.startTimer(3)
printCentered(h/2,"S")
sleep(.05)
printCentered(h/2,"St")
sleep(.05)
printCentered(h/2,"Sta")
sleep(.05)
printCentered(h/2,"Star")
sleep(.05)
printCentered(h/2,"Starl")
sleep(.05)
printCentered(h/2,"Starli")
sleep(.05)
printCentered(h/2,"Starlig")
sleep(.05)
printCentered(h/2,"Starligh")
sleep(.05)
printCentered(h/2,"Starlight")
sleep(.05)
term.setTextColor(colors.orange)
printCentered(h/2+1,string.rep("\129",9))
local key,withCtrl,withAlt,withShift = keys.one,true,false,false
local heldCtrl, heldAlt, heldShift, result = false, false, false, false
while true do
    local event, param1, param2 = os.pullEvent() -- wait for key
    if event == "key" then
        -- check if key is down, all modifiers are correct, and that it's not held
        if param1 == key and heldCtrl == withCtrl and heldAlt == withAlt and heldShift == withShift and not param2 then
            result = false
            break
        -- activate modifier keys
        elseif param1 == keys.leftCtrl or param1 == keys.rightCtrl then 
            heldCtrl = true
        elseif param1 == keys.leftAlt or param1 == keys.rightAlt then 
            heldAlt = true
        elseif param1 == keys.leftShift or param1 == keys.rightShift then 
            heldShift = true 
        end
    elseif event == "key_up" then
        -- deactivate modifier keys
        if param1 == keys.leftCtrl or param1 == keys.rightCtrl then 
            heldCtrl = false
        elseif param1 == keys.leftAlt or param1 == keys.rightAlt then 
            heldAlt = false
        elseif param1 == keys.leftShift or param1 == keys.rightShift then 
            heldShift = false 
        end
    elseif event == "timer" and param1 == id then
        result = true
        break
    end
end
if result == true then
    shell.run("/boot/PXBoot.sys /ect/PXBoot/bootconfig.conf.skip -i")
else
    shell.run("/boot/PXBoot.sys /ect/PXBoot/bootconfig.conf.skip")
end