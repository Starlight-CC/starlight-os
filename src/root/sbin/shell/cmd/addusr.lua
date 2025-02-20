local tArgs = { ... }
if #tArgs < 2 then
    print("Usage: addusr <name> <password>")
    return
end

local function contains(l,t)
    for i,v in ipairs(l) do
        if v == t then
            return true
        end
    end
    return false
end
    
if not contains(user[1],tArgs[1]) then
    fs.copy("/usr/*","home/"..os.username().."/")
else
    term.setTextColor(colors.red)
    print("User exists")
end