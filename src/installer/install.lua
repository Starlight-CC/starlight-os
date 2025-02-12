local repoPath = "https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/src/root/"

local file = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/src/installer/fs.lua")
local fh = fs.open("tmp/installerData.lua", "w")
fh.write(file.readAll())
fh.close()
local list = loadfile("tmp/installerData.lua")
local iso = list()

for i,v in ipairs(iso[1]) do
    print(v)
    local file = http.get(repoPath..v)
    local fh = fs.open(v, "w")
    fh.write(file.readAll())
    fh.close()
end

fs.delete("tmp/installerData.lua")
