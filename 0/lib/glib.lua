local lib = {}
function lib.printSprite(t,ox,oy)
  local tx = t[1]
  local ty = t[2]
  local x = 1
  local y = 1
  local idx = 1
  while x < tx + 1 do
    while y < ty + 1 do
      term.setCursorPos(ox+x,oy+y)
      term.setTextColor(colors.fromBlit(t[3][idx]))
      term.setBackgroundColor(colors.fromBlit(t[4][idx]))
      term.write(string.char(128 + t[5][idx]))
      y = y + 1
      idx = idx + 1
    end
    x = x + 1
    y = 1
  end
end

lib.exampleSprite = {
  4,4,
  {
    "0","1","2","3",
    "4","5","6","7",
    "8","9","a","b",
    "c","d","e","f"
  },
  {
    "f","e","d","c",
    "b","a","9","8",
    "7","6","5","4",
    "3","2","1","0"
  },
  {
    0,1,2,3,
    4,5,6,7,
    8,9,10,11,
    12,13,14,15
  }
}

return lib