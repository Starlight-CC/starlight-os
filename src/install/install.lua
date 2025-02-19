local repoPath = "https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/src/root/"
local start = false
if fs.exists("tmp/installerData.lua") then
    local list = loadfile("tmp/installerData.lua")
    local iso = list()
    start = true
else
    local file = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/src/install/data/sys.lua")
    local fh = fs.open("tmp/installerData.lua", "w")
    fh.write(file.readAll())
    fh.close()
    local list = loadfile("tmp/installerData.lua")
    local iso = list()
end
if iso[2] == "end" then
    term.setPaletteColor(colors.red,0xff0000)
    term.setPaletteColor(colors.green,0x00ff00)
    term.setPaletteColor(colors.blue,0x0000ff)
    term.clear()
    term.setCursorPos(1,1)
    term.write("Welcome to")
    term.setTextColor(colors.blue)
    term.write(" Starlight OS")
    print("")
    term.setTextColor(colors.green)
    sleep(1)
    fs.move("sys/startup.lua","startup.lua")
    print("Install complete rebooting...")
    sleep(1)
    print("SL.reboot service started")
    shell.run("/sys/serv/reboot.lua")
else
    term.setPaletteColor(colors.red,0xff0000)
    term.setPaletteColor(colors.green,0x00ff00)
    term.setPaletteColor(colors.blue,0x0000ff)
    term.clear()
    term.setCursorPos(1,1)
    if start then
        term.write("Welcome to")
        term.setTextColor(colors.blue)
        term.write(" Starlight OS")
        print("")
        sleep(1)
    end
    for i,v in ipairs(iso[1]) do
        local file = http.get(repoPath..v)
        if file == nil then 
            term.setTextColor(colors.red) 
            print(v..", failed to reach web address")
            fs.delete(v)
        else 
            term.setTextColor(colors.green)
            print(v) 
            local fh = fs.open(v, "w")
            fh.write(file.readAll())
            fh.close()
        end
    end
    fs.delete("tmp/installerData.lua")
    if start then
        fs.move(shell.getRunningProgram(),"startup.lua")
        term.setTextColor(colors.white)
        print("system will restart in 3")
        sleep(1)
        print("2")
        sleep(1)
        print("1")
        sleep(1)
    end
    term.setTextColor(colors.green)
    print("SL.reboot service started")
    shell.run("/sys/serv/reboot.lua")
end