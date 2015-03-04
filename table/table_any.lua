table.any = function(tbl, func)
    
    local haveFunc = func
    
    for i,v in ipairs(tbl) do
        if (haveFunc and func(v)) or (not haveFunc and v) then
            return true
        end
    end
    return false
    
    
end
