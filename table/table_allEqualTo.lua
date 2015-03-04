table.allEqualTo = function(tbl, x)
        
    return table.all(tbl, function(v) return x == v; end)    
    
end