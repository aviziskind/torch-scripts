table.anyEqualTo = function(tbl, x)
    if type(x) == 'table' and type(tbl) ~= 'table' then
        x,tbl = tbl,x
    end
        
    return table.any(tbl, function(v) return x == v; end)    
    
end