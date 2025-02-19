if term.isColour() then
    term.setTextColour(colours.blue)
end
print("rebooting")
term.setTextColour(colours.white)

sleep(1)
os.reboot()
