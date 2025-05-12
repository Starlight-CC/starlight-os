_G.require = require
local json = load(http.get("https://raw.githubusercontent.com/Starlight-CC/starlight-os/refs/heads/main/tools/SLC/json.la").readAll())()
local PrimeUI = load(http.get("https://raw.githubusercontent.com/Starlight-CC/starlight-os/refs/heads/main/tools/SLC/PrimeUI.la").readAll())()
local versions = json.decode(http.get("https://api.github.com/repos/Starlight-CC/starlight-os/contents/versions/").readAll())
local data = {}
for i,v in ipairs(versions) do
    if v.name == ".ignore" then else
    local filename = v.name
    local compile = string.sub(filename,11,#filename-3)
    local idx = 1
    while idx <= #compile do
        if string.sub(compile,idx,idx) == "|" then
            break
        else idx=idx+1 end
    end
    local version = string.sub(Compile,1,idx-1)
    local time = string.sub(compile,idx+1)
    local is_hotfix = false
    if string.sub(filename,11,11) == "H" then
        is_hotfix = true
    end
    data[i]={
        filename=filename,
        compile=compile,
        version=version,
        time=time,
        is_hotfix=is_hotfix
    }
end
end
local display = {}
for i,v in ipairs(data) do
    display[tostring(v.version)]=v
end
PrimeUI.clear()


