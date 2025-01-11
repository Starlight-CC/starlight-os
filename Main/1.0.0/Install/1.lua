local filename = "STARLIGHTOS/Sys/BIOS.lua"--filename
local file = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/Main/1.0.0/STARLIGHTOS/Sys/BIOS.lua")--url
local fh = fs.open(filename, "w")
fh.write(file.readAll())
fh.close()