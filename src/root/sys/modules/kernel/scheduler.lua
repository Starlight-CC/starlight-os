local Scheduler = {}
Scheduler.stack = {}
Scheduler.next = 1
Scheduler.time = 0
Scheduler.channels = {}

function Scheduler.queue(func,name,priority)
    local id = Scheduler.next
    Scheduler.next = Scheduler.next + 1
    if priority == nil then
        priority = 5
    end
    if name == nil then
        name = tostring(id)
    end
    local ret = {}
    function ret.kill()
        Scheduler.stack[tostring(id)]=nil
    end
    function ret.suspend()
        Scheduler.stack[tostring(id)].status="suspended"
    end
    function ret.resume()
        Scheduler.stack[tostring(id)].status="waiting"
    end
    function ret.getinfo()
        return {
            id=id,
            status=Scheduler.stack[tostring(id)].status,
            priority=Scheduler.stack[tostring(id)].priority,
            handles=Scheduler.stack[tostring(id)].handles
        }
    end
    local co,err = coroutine.create(func)
    if co == nil then
        error(err)
    end
    Scheduler.stack[tostring(id)]={
        thread=co,
        name=name,
        id=id,
        status="created",
        priority=priority,
        handles={}
    }
    return ret
end

function Scheduler