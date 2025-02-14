local repoPath = "https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/src/root/"

local file = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/src/installer/fs.lua")
local fh = fs.open("tmp/installerData.lua", "w")
fh.write(file.readAll())
fh.close()
local list = loadfile("tmp/installerData.lua")
local iso = list()
term.setPaletteColor(colors.red,0xff0000)
term.setPaletteColor(colors.green,0x00ff00)
term.setPaletteColor(colors.blue,0x0000ff)
term.clear()
term.setCursorPos(1,1)
term.write("Welcome to")
term.setTextColor(colors.blue)
term.write(" Starlight OS")
print("")
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
