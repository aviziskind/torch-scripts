torch.toTable = function(x, preserveDimensions_flag)
    if not torch.isTensor(x) then
        error('Input must be a torch tensor')
    end
   
    local tbl = {}
    
    local n1 = x:size(1) 

    if not preserveDimensions_flag then  -- put all elements into a table
        local s = x:storage()
        local n = s:size()
    
        for i = 1,n do
            tbl[i] = s[i]
        end

    elseif preserveDimensions_flag then
    
        if (x:dim() > 1) then
            
            for i = 1,n1 do -- recurse
                tbl[i] = torch.toTable(x[i], 1)
            end
            
        else            
            
            for i = 1,n1 do  -- fill in last layer
                tbl[i] = x[i]
            end
        end
    end
    
    return tbl
    
end