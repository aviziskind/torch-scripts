table.apply = function(func, tbl)
    local t = {}
    for i,v in ipairs(tbl) do
        --print(i)
        t[i] = func(v)
    end
    return t
    
end