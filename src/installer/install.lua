local repoPath = "https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/src/root/"

local iso = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/src/installer/fs.lua")

for i,v in ipairs(iso[1]) do
    local file = http.get(repoPath..v)
    local fh = fs.open(v, "w")
    fh.write(file.readAll())
    fh.close()
end
