local LOGO_FILE = "Starlight_OS/Main/1.0.0/files/programs/neofetch/logo.txt"

local LOGO_COLOUR = 512
local C1 = 512
local C2 = 32
local BG_COLOUR = 32768

local LOGO_WIDTH = 25
local LOGO_HEIGHT = 15

-- TMP ENV
USERNAME = "test"
HOSTNAME = "test"
UNAME = {
    OS="StarlightOS",
    KERNEL="1.0.0-slos"
}

-- Functions

local function endOfLogo()
    local _, py = term.getCursorPos()
    term.setCursorPos(LOGO_WIDTH+1, py)
end

-- Prints the logo
term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1,1)
local defaultColour = term.getTextColour()

local logoFile = fs.open(LOGO_FILE, "rb")
term.setTextColour(LOGO_COLOUR)
print(logoFile.readAll())
logoFile.close()

-- Displays information

local l2 = ""
for i=1,#USERNAME+#HOSTNAME+1 do
    l2 = l2.."-"
end

local sx, sy = term.getSize()

local infoTxt = {
    {"OS", UNAME.OS},
    {"Kernel", UNAME.KERNEL},
    {"Term. Size", sx.."x"..sy},
    {"Computer ID", os.computerID()},
    {"Space used", tostring((fs.getCapacity("/")-fs.getFreeSpace("/"))/1000).."KB".."/"..tostring(fs.getCapacity("/")/1000).."KB"}
}

local px, py = term.getCursorPos()
term.setCursorPos(LOGO_WIDTH+1, py-LOGO_HEIGHT)
term.setTextColour(C1)
term.write(USERNAME)
term.setTextColour(C2)
term.write("@")
term.setTextColour(C1)
print(HOSTNAME)
endOfLogo()
term.setTextColour(C2)
print(l2)

for _,v in pairs(infoTxt) do
    endOfLogo()
    term.setTextColour(C1)
    term.write(v[1])
    term.setTextColour(C2)
    print(": "..v[2])
    os.sleep(0.1)
end

term.setTextColour(defaultColour)
term.setCursorPos(px, py+1)


sleep(5)