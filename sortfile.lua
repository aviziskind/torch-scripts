if not arg[1] then
    print("No input file")
    return
else

    print("Sorting file " .. arg[1])

     f = io.open(arg[1])
     if not f then
        print("Could not open file")
        return;
     end
     f:close()

     local lines = {}
    -- read the lines in table 'lines'
    for line in io.lines(arg[1]) do
      --print(line)
      table.insert(lines, line)
    end
    -- sort
    table.sort(lines)
    print(lines)
    

end
