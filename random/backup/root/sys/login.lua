--os.pullEvent = os.pullEventRaw

-- edit os API

function os.username(e)
  if user == nil then
    user = e
    return true
  else
    return user
  end
end

function os.hostname(e)
  if host == nil then
    host = e
    return true
  else
    return host
  end
end

function os.getUsers()
  file = fs.open(".users","r")
  local e = file.readAll()
  file.close()
  return e 
end
shell.run("mkdir /home/Astronand/")
os.username("Astronand")
os.hostname("Mainframe")
shell.run("/boot/startup.lua")