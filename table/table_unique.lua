table.unique = function(tbl)
    
    if not type(tbl) == 'table' then
        error('This function is only for tables')
    end
   
    -- create list of booleans to keep track of which entries are unique
    local n = #tbl;
    local idx_use = {}
    for i = 1,n do
        table.insert(idx_use, true)
    end
    
    
    -- for each entry in the table, compare to all previous entries
    for i = 2,n do
        for j = 1,i-1 do
            if isequal(tbl[i], tbl[j]) then
                idx_use[i] = false
                break
            end
        end
    end
    
    -- gather all unique entries
    local uTbl = {}
    local idx_orig = {}
    for i = 1,n do        
        if idx_use[i] then
            table.insert(uTbl, tbl[i])
            table.insert(idx_orig, i)
        end
    end
    
    return uTbl, idx_orig
end