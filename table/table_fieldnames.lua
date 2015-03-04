table.fieldnames = function(tbl)
    
    local names = {}
    for k,v in pairs(tbl) do
        table.insert(names, k)
    end
    return names
    
end