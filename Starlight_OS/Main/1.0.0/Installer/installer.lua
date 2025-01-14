
FILESYSTEM_URL = ""
FILES_URL = ""

-- Get filesystem and file list

local req = http.get(FILESYSTEM_URL)
if not req then
    error("Unable to get filesystem table.")
    return
end
local fstab = textutils.deserializeJSON(req.readAll())
req.close()

local req = http.get(FILES_URL)
if not req then
    error("Unable to get file list.")
    return
end
local flist = textutils.deserializeJSON(req.readAll())
req.close()

-- Creates all folders

for i,v in pairs(fstab) do
    fs.makeDir(v)
end

-- Downloads and creates required files

for i,v in pairs(flist) do
    local req = http.get(FILES_URL.."/"..i)
    if not req then
        error("Unable to download file: "..i)
        return
    end
    local f = fs.open(v, "wb")
    f.write(req.readAll())
    f.close()
    req.close()
end