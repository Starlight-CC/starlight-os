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
  local a = b
  local x = 1
  local y = 1
  local tx,ty = term.getSize()
  while y < ty + 1 do
    while x < tx + 1 do
      term.setCursorPos(x,y)
      term.setTextColor(a[tostring(x)..","..tostring(y).."t"])
      term.setBackgroundColor(a[tostring(x)..","..tostring(y).."b"])
      term.write(a[tostring(x)..","..tostring(y).."c"])
      x = x + 1
    end
    y = y + 1
    x = 1
  end
end

function lib.buffer.create(t,b)
  local a = {}
  local x = 1
  local y = 1
  local tx,ty = term.getSize()
  while y < ty + 1 do
    while x < tx + 1 do
      local tbx,tby = x,y
      a[tostring(tbx)..","..tostring(tby).."t"] = t
      a[tostring(tbx)..","..tostring(tby).."b"] = b
      a[tostring(tbx)..","..tostring(tby).."c"] = 0
      x = x + 1
    end
    y = y + 1
    x = 1
  end
  return a
end

function lib.sprite.collide(s1,x1,y1,s2,x2,y2)
  local box1 = {}
  local x = x1
  local y = y1
  while y < y1+s1[2] do
    while x < x1+s1[1] do
      table.insert(box1,1,tostring(x)..","..tostring(y))
      x = x + 1
    end
    y = y + 1
    x = 1
  end
  local box2 = {}
  local x = x2
  local y = y2
  while y < y2+s2[2] do
    while x < x2+s2[1] do
      table.insert(box2,1,tostring(x)..","..tostring(y))
      x = x + 1
    end
    y = y + 1
    x = 1
  end
  for _,v in ipairs(box1) do
    for _,i in ipairs(box2) do
      if i == v then
        return true
      end
    end
  end
  return false
end


return lib