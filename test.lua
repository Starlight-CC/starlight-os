local i = 1
while i < 101 do
    shell.run("emu open "..tostring(i))
    i = i + 1
end
