term.clear()
term.setCursorPos(1,1)
term.write("Welcome to ")
term.setTextColor(colors.blue)
term.write("Starlight OS")
term.setTextColor(colors.white)
term.write("!")
term.setCursorPos(1,2)
sleep(1.5)
print("formating FS")
sleep(.5)
print("SFS Formated")
print("making Directorys")

--local FS = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/Starlight_OS_Adv/Main/1.0.0/Installer/FS.json")
local FS = {
    "",
    {
        "/",
        "/bin/",
        "/lib/",
        "/boot/",
        "/root/",
        "/root/",
        "/root/",
        "/root/",
        "/root/",
        "/root/",
        "/root/",
        "/root/",
        "/root/",
        "/root/",
        "/root/",
        "/sys/"
    }
}

root = FS[1]
l1 = FS[2]

for i,v in ipairs(l1) do
    local x,y = term.getCursorPos()
    fs.makeDir(v)
    term.write("[ ")
    term.setTextColor(colors.green)
    term.write("OK")
    term.setTextColor(colors.white)
    term.write(" ] mkDir "..v)
    if y == 19 then
        term.scroll()
        term.setCursorPos(1,19)
    else
        term.setCursorPos(1,y+1)
    end
    sleep(0)
end

files = FS[2]

