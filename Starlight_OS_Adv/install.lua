local w,h = term.getSize()
 
function printCentered( y,s )
  local x = math.floor((w - string.len(s)) / 2)
  term.setCursorPos(x,y)
  term.clearLine()
  term.write( s )
end
 
local nOption = 1
 
local function drawMenu()
  term.clear()
  term.setCursorPos(1,1)
  term.write("STARLIGHT // ")
  term.setCursorPos(1,2)
  term.write(os.getComputerID())
  term.setCursorPos(1,h)
  if nOption == 1 then
    term.write("Install OS")
  elseif nOption == 2 then
    term.write("Exit to shell")
  else
  end
end
 
--GUI
term.clear()
local function drawFrontend()
  printCentered(math.floor(h/2) - 3, "")
  printCentered(math.floor(h/2) - 2, "Install ''Starlight'' OS" )
  printCentered(math.floor(h/2) - 1, "")
  printCentered(math.floor(h/2) + 0, ((nOption == 1) and "[  Install     ]") or "Install      ")
  printCentered(math.floor(h/2) + 1, ((nOption == 2) and "[  Exit        ]") or "Exit         ")
  printCentered(math.floor(h/2) + 2, "")
end

--Display
drawMenu()
drawFrontend()
 
while true do
  local e,p = os.pullEvent()
  w,h = term.getSize()
  if e == "key" then
    local key = p
    if key == 265 or key == 200 then
      if nOption > 1 then
        nOption = nOption - 1
        drawMenu()
        drawFrontend()
      end
    elseif key == 264 or key == 208 then
      if nOption < 2 then
        nOption = nOption + 1
        drawMenu()
        drawFrontend()
      end
    elseif key == 257 or key == 28 then
      --when enter pressed
    break
    end
  end
  if e == "term_resize" then
    w,h = term.getSize()
  end
end
term.clear()
 
--Conditions
if nOption  == 1 then
  w,h = term.getSize()
  
  local nOption = 1
  
  local function drawMenu2()
    term.clear()
    term.setCursorPos(1,1)
    term.write("STARLIGHT // ")
    term.setCursorPos(1,2)
    term.write(os.getComputerID())
    term.setCursorPos(1,h)
    if nOption == 1 then
      term.write("Install OS")
    elseif nOption == 2 then
      term.write("Exit to shell")
    else
    end
  end
  
  --GUI
  term.clear()
  local function drawFrontend2()
    printCentered(math.floor(h/2) - 3, "")
    printCentered(math.floor(h/2) - 2, "This will delete everything on the / drive" )
    printCentered(math.floor(h/2) - 1, "")
    printCentered(math.floor(h/2) + 0, ((nOption == 1) and "[  OK          ]") or "OK           ")
    printCentered(math.floor(h/2) + 1, ((nOption == 2) and "[  Exit        ]") or "Exit         ")
    printCentered(math.floor(h/2) + 2, "")
  end

  --Display
  drawMenu2()
  drawFrontend2()
  
  while true do
    local e,p = os.pullEvent()
    w,h = term.getSize()
    if e == "key" then
      local key = p
      if key == 265 or key == 200 then
        if nOption > 1 then
          nOption = nOption - 1
          drawMenu2()
          drawFrontend2()
        end
      elseif key == 264 or key == 208 then
        if nOption < 2 then
          nOption = nOption + 1
          drawMenu2()
          drawFrontend2()
        end
      elseif key == 257 or key == 28 then
        --when enter pressed
      break
      end
    end
    if e == "term_resize" then
      w,h = term.getSize()
    end
  end
  term.clear()
  
  --Conditions
  if nOption  == 1 then
    -- Function to recursively delete all files and folders in a directory except specified files or folders
    local function deleteFiles(directory, exceptions)
      for _, entry in ipairs(fs.list(directory)) do
        local fullPath = fs.combine(directory, entry)
        if fs.isDir(fullPath) then
          if not exceptions[entry] then
            deleteFiles(fullPath, exceptions)
            fs.delete(fullPath) -- Delete the folder after deleting its contents
          end
        elseif not exceptions[entry] then
          fs.delete(fullPath) -- Delete the file
        end
      end
    end
    local exceptions = {
      ["rom"] = true,
      ["Install.lua"] = true
    }
    -- Specify the path to the target directory
    local targetDir = "/"
    -- Call the function to delete files and folders, passing the target directory and exceptions table
    deleteFiles(targetDir, exceptions)
    
    w,h = term.getSize()
  
    local nOption = 1
    
    local function drawMenu2()
      term.clear()
      term.setCursorPos(1,1)
      term.write("STARLIGHT // ")
      term.setCursorPos(1,2)
      term.write(os.getComputerID())
      term.setCursorPos(1,h)
      if nOption == 1 then
        term.write("Install OS")
      elseif nOption == 2 then
        term.write("Exit to shell")
      else
      end
    end
    
    --GUI
    term.clear()
    local function drawFrontend2()
      printCentered(math.floor(h/2) - 3, "")
      printCentered(math.floor(h/2) - 2, "This will delete everything on the / drive" )
      printCentered(math.floor(h/2) - 1, "")
      printCentered(math.floor(h/2) + 0, ((nOption == 1) and "[  OK          ]") or "OK           ")
      printCentered(math.floor(h/2) + 1, ((nOption == 2) and "[  Exit        ]") or "Exit         ")
      printCentered(math.floor(h/2) + 2, "")
    end
  
    --Display
    drawMenu2()
    drawFrontend2()
    
    while true do
      local e,p = os.pullEvent()
      w,h = term.getSize()
      if e == "key" then
        local key = p
        if key == 265 or key == 200 then
          if nOption > 1 then
            nOption = nOption - 1
            drawMenu2()
            drawFrontend2()
          end
        elseif key == 264 or key == 208 then
          if nOption < 2 then
            nOption = nOption + 1
            drawMenu2()
            drawFrontend2()
          end
        elseif key == 257 or key == 28 then
          --when enter pressed
        break
        end
      end
      if e == "term_resize" then
        w,h = term.getSize()
      end
    end
    term.clear()
    
    local file = http.get()
    local fh = fs.open("/temp/Install.lua", "w")
    fh.write(file.readAll())
    fh.close()

    local file = http.get(link[nOption])
    local fh = fs.open("/temp/Install.lua", "w")
    fh.write(file.readAll())
    fh.close()

    
  elseif nOption == 2 then
    term.setCursorPos(1,1)
    term.clear()
  else
  end
elseif nOption == 2 then
  term.setCursorPos(1,1)
  term.clear()
else
end





