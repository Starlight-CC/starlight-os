term.clear()
term.setCursorPos(1,1)

local file = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/Starlight_OS_Adv/Main/1.0.0/Installer/FS.json")
local fh = fs.open("/temp/FS.json", "w")
fh.write(file.readAll())
fh.close()