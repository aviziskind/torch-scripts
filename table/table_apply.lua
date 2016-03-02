table.apply = function(tbl, func)
    local t = {}
    for i,v in ipairs(tbl) do
        --print(i)
        t[i] = func(v)
    end
    return t
    
end