table.intersect = function(a, b)
    local c = {}
    
    for k1,v1 in pairs(a) do
        
        for k2, v2 in pairs(b) do
            if (v1 == v2) then
                table.insert(c, v1)
                break
            end
        end
        
    end
   
    return c
    
    
end

