table.keys = function(tbl)
    
    fn = {}
    idx = 1
    for key,_ in pairs(tbl) do
        fn[idx] = key
        idx = idx + 1
    end
    return fn
    
end
