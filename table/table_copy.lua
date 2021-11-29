table.copy = function(tbl)
    
    local slow = true
    
    local tbl_copy = {}
    for k,v in pairs(tbl) do
        VV = v
        local type_v = getType(v)
        local torch_type = torch.typename(v)
        --io.write(string.format('%s : %s\n', tostring(k), tostring(v) ))
        --sleep(2)
        
        
        if (type_v == 'number') or (type_v == 'boolean') or (type_v == 'function') then
            tbl_copy[k] = v
            
        elseif (type_v == 'string') then
            tbl_copy[k] = v  -- returns a reference to the string (strings are immutable in lua, like in c)
                
            
        elseif torch_type then
                
            if string.find(type_v, 'Tensor') then
                
                tbl_copy[k] = v:clone()
                --if (v:nElement() == 0) then --and (type_v == 'CudaTensor') then
                --    tbl_copy[k] = torch.Tensor(0):typeAs(v)
                --else
                --    tbl_copy[k] = v:clone()
                --end
                
            elseif string.find(type_v, 'Storage') then
           
                tbl_copy[k] = torch.StorageOfType(v:size(), torch.typename(v)):copy(v)
            else
                tbl_copy[k] = v:clone()
                --error(string.format('Unhandled torch type : %s', torch_type))
            end
          
        
        elseif (type_v == 'table') then
            tbl_copy[k] = table.copy(v) -- recurse
            
        else    
            error('copy table not yet implemented for type ' .. type_v)
            
        end
        
    end
    
    return tbl_copy
 
end
