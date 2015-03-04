table.all = function(tbl, func)
    
    local haveFunc = func
    
    for i,v in ipairs(tbl) do
        if not ( (haveFunc and func(v)) or (not haveFunc and v) ) then        
            return false
        end
    end
    return true
    
    
end