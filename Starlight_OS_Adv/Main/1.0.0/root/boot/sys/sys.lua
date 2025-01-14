local lib = {}

function lib.dep()
    local dep = {

    }
end

function lib.version()
    return "1.0.0"
end

function lib.loadGlobalAPIs()
    local globals = fs.list("/lib/global/")
    for i,v in ipairs(globals) do
        os.loadAPI("/lib/global/"..v)
    end
    return globals
end



return lib