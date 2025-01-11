local filename = "STARLIGHTOS/Sys/BIOS.lua"--filename
local file = http.get("")--url
local fh = fs.open(filename, "w")
fh.write(file.readAll())
fh.close()