local lib = {}

function lib.makeEnv(w,h,x,y,bg,tx)
    local ret = {
        w,h,x,y,bg,tx,
        canvas = {

        }
    }
end

function lib.printCenter(e,t,y)
    e.canvas[#e.canvas+1] = {"print",t,e[1]/2-#t/2,y}
end

return lib