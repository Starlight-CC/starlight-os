local lib = {}

function lib.dep()
    local dep = {
        "/lib/sys"
    }
    return dep
end

function lib.createUser(username,password)
    local OS = require("/lib/sys")
    local wd = "/home/"..username
    fs.makeDir(wd.."/desktop/")
    fs.makeDir(wd.."/documents/")
    fs.makeDir(wd.."/downloads/")
    file = fs.open(wd.."/.info", "w")
    file.write(
        {
            username = username,
            password = password,
            perm = 2,
            created = os.date()
        }
    )
    file.close()
end

function lib.getUserData(data)
    local wd = "/home/"..sys.getActiveUser()
    file = fs.open(wd.."/.info", "r")
    userData = file.readAll()
    file.close()
    if data == nil then
        return userData
    else
        return userData[data]
        
end

return lib