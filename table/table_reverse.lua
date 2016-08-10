table.reverse = function(tbl)
    n = #tbl
    new_tbl = {}
    for i = n,1, -1 do
        table.insert(new_tbl, tbl[i])
    end
    
    return new_tbl
    
    
end