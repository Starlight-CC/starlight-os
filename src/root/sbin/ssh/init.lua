local tArgs = {...}
local shellC = "/rom/programs/shell.lua"
local tFlags = {
    port = 22,
    user = "id", --User
    setHost = false, --Host?
    close = false,
    ip=tostring(math.random(0,225)).."."..tostring(math.random(0,225)).."."..tostring(math.random(0,225)),
    connected=""
}
print(tFlags.ip)
local modem = peripheral.find("modem")
local function send(address,Itype,query,...)
    modem.transmit(tFlags.port,tFlags.port,{
        _SSHPACKET=true,
        address=address,
        returnAddress=tFlags.ip,
        type=Itype,
        query=query,
        data=(...)
    })
end
for i,v in ipairs(tArgs) do
    if v.sub(1,3) == "-u=" then
        tFlags.user=v.sub(4)
    elseif v.sub(1,3) == "-p=" then
        tFlags.port=tonumber(v.sub(4))
    elseif v.sub(1,4) == "host" then
        tFlags.setHost=true
    elseif v.sub(1,5) == "close" then
        send(tFlags.connected,"SSH","disconect","SESSION CLOSED")
    else
        tFlags.connected=v
    end
end
modem.open(tFlags.port)
if tFlags.setHost then
    _SSH={Host=true}
    _SSH.term=term
    term = {
        clearLine=function(...)
            send(tFlags.connected,"term","clearLine",...)
            _SSH.term.clearLine(...)
        end,
        getCursorBlink=function(...)
            return _SSH.term.getCursorBlink(...)
        end,
        getTextColor=function(...)
            return _SSH.term.getTextColor(...)
        end,
        redirect=function(...)
            return _SSH.term.redirect(...)
        end,
        getBackgroundColour=function(...)
            return _SSH.term.getBackgroundColour(...)
        end,
        write=function(...)
            send(tFlags.connected,"term","write",...)
            _SSH.term.write(...)
        end,
        setCursorBlink=function(...)
            send(tFlags.connected,"term","setCursorBlink",...)
            _SSH.term.setCursorBlink(...)
        end,
        setBackgroundColour=function(...)
            send(tFlags.connected,"term","setBackgroundColour",...)
            _SSH.term.setBackgroundColour(...)
        end,
        getBackgroundColor=function(...)
            return _SSH.term.getBackgroundColor(...)
        end,
        setPaletteColour=function(...)
            send(tFlags.connected,"term","setPaletteColour",...)
            _SSH.term.setPaletteColour(...)
        end,
        current=function(...)
            return _SSH.term.current(...)
        end,
        isColor=function(...)
            return _SSH.term.isColor(...)
        end,
        clear=function(...)
            send(tFlags.connected,"term","clear",...)
            _SSH.term.clear(...)
        end,
        blit=function(...)
            send(tFlags.connected,"term","blit",...)
            _SSH.term.blit(...)
        end,
        setPaletteColor=function(...)
            send(tFlags.connected,"term","setPaletteColor",...)
            _SSH.term.setPaletteColor(...)
        end,
        getPaletteColour=function(...)
            return _SSH.term.getPaletteColour(...)
        end,
        native=function(...)
            return _SSH.term.native(...)
        end,
        setBackgroundColor=function(...)
            send(tFlags.connected,"term","setBackgroundColor",...)
            _SSH.term.setBackgroundColor(...)
        end,
        isColour=function(...)
            return _SSH.term.isColour(...)
        end,
        setCursorPos=function(...)
            send(tFlags.connected,"term","setCursorPos",...)
            _SSH.term.setCursorPos(...)
        end,
        nativePaletteColour=function(...)
            return _SSH.term.nativePaletteColor(...)
        end,
        setTextColor=function(...)
            send(tFlags.connected,"term","setTextColor",...)
            _SSH.term.setTextColor(...)
        end,
        getTextColour=function(...)
            return _SSH.term.getTextColour(...)
        end,
        getSize=function(...)
            return _SSH.term.getSize(...)
        end,
        setTextColour=function(...)
            send(tFlags.connected,"term","setTextColour",...)
            _SSH.term.setTextColour(...)
        end,
        getPaletteColor=function(...)
            return _SSH.term.getPaletteColor(...)
        end,
        scroll=function(...)
            send(tFlags.connected,"term","scroll",...)
            _SSH.term.scroll(...)
        end,
        getCursorPos=function(...)
            return _SSH.term.getCursorPos(...)
        end,
        nativePaletteColor=function(...)
            return _SSH.term.nativePaletteColor(...)
        end
    }
    print("your id is "..tFlags.ip)
    parallel.waitForAny(
        function()
            shell.run(shellC)
        end,
        function()
            while not tFlags.close do
                local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
                if type(message) == "table" then
                    if message._SSHPACKET then
                        if message.address == tFlags.ip then
                            if message.type == "SSH" then
                                if message.query == "connect" then
                                    if tFlags.user == "id" then
                                        tFlags.user=message.data[1]
                                        tFlags.connected=message.returnAddress
                                    else
                                        send(message.returnAddress,"SSH","reject","Already connected")
                                    end
                                elseif message.query == "disconnect" then
                                    if tFlags.user == message.data[1] then
                                        tFlags.user="id"
                                    end
                                end
                            elseif message.type == "key" then
                                if message.query == "key" then
                                    os.queueEvent("key",message.data[1],message.data[2])
                                elseif message.query == "key_up" then
                                    os.queueEvent("key_up",message.data[1])
                                end
                            end
                        end
                    end
                end
            end
        end
    )
elseif tFlags.close then
    if _SSH.term then
        term=_SSH.term
        _SSH=nil
    end
else
    send(connected,"SSH","connect",tFlags.ip)
    while true do
        local event, side, channel, replyChannel, message, distance = os.pullEvent()
        if event == "key" then
            send(connected,"key","key",side,channel)
        elseif event == "key_up" then
            send(connected,"key","key_up",side)
        elseif event == "modem_message" then
            if message._SSHPACKET then
                if message.address == tFlags.ip then
                    if message.type == "SSH" then
                        if message.query == "reject" then
                            error(message.data[1])
                        end
                    elseif message.type == "term" then
                        term[message.query](message.data)
                    end
                end
            end
        end
    end
end
