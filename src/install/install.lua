local repoPath = "https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/src/root/"
local start = false
os.pullEvent = os.pullEventRaw
if fs.exists("tmp/installerData.dat") then
    local list = loadfile("tmp/installerData.dat")
    iso = list()
else
    local file = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/src/install/data/sys.dat")
    local fh = fs.open("tmp/installerData.dat", "w")
    fh.write(file.readAll())
    fh.close()
    local list = loadfile("tmp/installerData.dat")
    iso = list()
    start = true
end
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
print("installing "..iso[4])
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
term.setTextColor(colors.green)
for i,v in ipairs(iso[3]) do
    print(v)
    shell.run(v)
end
fs.delete("tmp/installerData.dat")
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
    if fs.exists("sbin/SLInstall.lua") then
        fs.delete("sbin/SLInstall.lua")
    end
    fs.move("startup.lua","sbin/SLInstall.lua")
    fs.move("sys/startup.lua","startup.lua")
    fs.delete("tmp/installerData.dat")
    print("Install complete rebooting...")
    sleep(1)
    print("SL.reboot service started")
    shell.run("/sys/serv/reboot.lua")
end
local file = http.get(iso[2])
local fh = fs.open("tmp/installerData.dat", "w")
fh.write(file.readAll())
fh.close()
if start then
    if fs.exists("startup.lua") then
        if fs.exists("startup.lua.old") then
            fs.delete("startup.lua.old")
        end
        fs.move("startup.lua","startup.lua.old")
    end
    local file = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/src/install/install.lua")
    local fh = fs.open("startup.lua", "w")
    fh.write(file.readAll())
    fh.close()
    term.setTextColor(colors.green)
    print("Updating Installer")
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
