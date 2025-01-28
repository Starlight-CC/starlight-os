local lib = {}
lib.sprite = {}
lib.buffer = {}
function lib.sprite.draw(t,ox,oy,b)
  if b == nil then
    local tx = t[1]
    local ty = t[2]
    local x = 1
    local y = 1
    local idx = 1
    while y < ty + 1 do
      while x < tx + 1 do
        term.setCursorPos(ox+x,oy+y)
        term.setTextColor(colors.fromBlit(t[3][idx]))
        term.setBackgroundColor(colors.fromBlit(t[4][idx]))
        term.write(string.char(128 + t[5][idx]))
        x = x + 1
        idx = idx + 1
      end
      y = y + 1
      x = 1
    end
  else
    local a = b
    local tx = t[1]
    local ty = t[2]
    local x = 1
    local y = 1
    local idx = 1
    while y < ty + 1 do
      while x < tx + 1 do
        local tbx,tby = ox+x,oy+y
        a[tostring(tbx)..","..tostring(tby).."t"] = colors.fromBlit(t[3][idx])
        a[tostring(tbx)..","..tostring(tby).."b"] = colors.fromBlit(t[4][idx])
        a[tostring(tbx)..","..tostring(tby).."c"] = string.char(128 + t[5][idx])
        x = x + 1
        idx = idx + 1
      end
      y = y + 1
      x = 1
    end
    return a
  end
end

lib.sprite.example = {
  4,4,
  {
    "f","f","f","f",
    "f","4","f","f",
    "4","4","4","1",
    "f","f","f","f"
  },
  {
    "f","f","f","f",
    "4","4","0","1",
    "f","4","4","f",
    "f","f","f","f"
  },
  {
    0,1,2,3,
    7,5,4,11,
    11,9,10,4,
    12,13,14,15
  }
}

function lib.buffer.print(b)

end

function lib.buffer.create()
  local a = {}
  local x = 1
  local y = 1
  local tx,ty = term.getSize()
  while y < ty + 1 do
    while x < tx + 1 do
      local tbx,tby = x,y
      a[tostring(tbx)..","..tostring(tby).."t"] = "f"
      a[tostring(tbx)..","..tostring(tby).."b"] = "f"
      a[tostring(tbx)..","..tostring(tby).."c"] = 0
      x = x + 1
    end
    y = y + 1
    x = 1
  end
  return a
end

return lib