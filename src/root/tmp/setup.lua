local function deleteFiles(dir)
    for _,v in ipairs(fs.list(dir)) do
        if fs.isDir(dir..v) then
            deleteFiles(dir..v.."/")
        else
            if v == ".pathGeneration" then
                fs.delete(dir..v)
            end
        end
    end
end