local tArgs = { ... }
if #tArgs < 1 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: [arg] <string>")
    print("Usage: <string>")
    return
end

if string.sub(tArgs[1],#tArgs[1]-2) == ".sh" then
  local file = fs.open(tArgs[1],"r")
  local text = ""
  while true do
    text = file.readLine(true)
    if text == "end" then
      break
    else
      shell.run(text)
    end
  end
else
  shell.run(tArgs[1])
end