-- Run system autorun files
if fs.exists("/ect/autorun/") and fs.isDir("/ect/autorun/") then
    local tFiles = fs.list("/ect/autorun/")
    for _, sFile in ipairs(tFiles) do
        local sPath = "/ect/autorun/" .. sFile
        if not fs.isDir(sPath) then
            shell.run("run "..sPath)
        end
    end
end