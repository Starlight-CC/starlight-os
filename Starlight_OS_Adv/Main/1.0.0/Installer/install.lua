





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
end

local exceptions = {
  ["rom"] = true,
  ["Install.lua"] = true
}

-- Specify the path to the target directory
local targetDir = "/"

-- Call the function to delete files and folders, passing the target directory and exceptions table
deleteFiles(targetDir, exceptions)