local tArgs = { ... }
if #tArgs < 2 then
    print("Usage: cmpr <file in> <file out>")
    return
end
local minify = require("minify")
fi = fs.open(tArgs[1],"r")
fo = fs.open(tArgs[2],"w")
fo.write(minify.minify(Fi.readAll()))
fi.close()
fo.close()