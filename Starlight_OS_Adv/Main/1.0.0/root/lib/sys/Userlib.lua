local lib = {}

function lib.dep()
    local dep = {
        "root/lib/sys/OSUtils"
    }
    return dep
end

function lib.createUser(username,password)
    local os = require("root/lib/sys/OSUtils")
    local wd = "root/home/"..username
    fs.makeDir(wd.."/desktop/")
    fs.makeDir(wd.."/documents/")
    fs.makeDir(wd.."/downloads/")
    file = fs.open(wd.."/.info", "w")
    file.write(
        {
            username,
            password,
            2,
            os.date()
        }
    )
    file.close()
end

function lib.getUserData(username,data)
    local wd = "root/home/"..username
    file = fs.open(wd.."/.info", "r")
    userData = file.readAll()
end

return lib