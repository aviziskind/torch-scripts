isequal = function(x,y, maxNCompare_tbl)
    local haveMaxN = maxNCompare_tbl ~= nil
    
    if haveMaxN and (maxNCompare_tbl < 1) then
        error('Undefined behavior')
    end
    
    local debug = false
    
    local type_x = getType(x)
    local type_y = getType(y)
    local reason
    
    if maxNCompare_tbl == 1 then
        if type_x == 'table' then
            x = x[1]
            type_x = getType(x)
        end
        if type_y == 'table' then
            y = y[1]
            type_y = getType(y)
        end
        
    end
    
    
    if type_x ~= type_y then
        reason = string.format('Different types (%s vs %s)', type_x, type_y)
        return false
    end
    
    if type_x == 'number' or type_x == 'string' or type_x == 'nil' or type_x == 'boolean' then
        return x == y
    end
    
    if string.sub(type_x, 1,5) == 'torch' then
        if string.find(type_x, 'Tensor') then
            return torch.tensorsEqual(x, y)
        elseif string.find(type_x, 'Storage') then
            return torch.storagesEqual(x, y)
        end
            
    end
    
    
    if type_x == 'table' and haveMaxN then  -- compare only the first maxN elements of the table [assuming array indexing]
        local haveMaxN = maxNCompare_tbl ~= nil
        
        if haveMaxN then
            nCmpX = math.min(#x, maxNCompare_tbl)
            nCmpY = math.min(#y, maxNCompare_tbl)
        else
            nCmpX = #x
            nCmpY = #y
        end
        
        if nCmpX ~= nCmpY then
            --print('different nCmp', nCmpX, nCmpY)

            return false
        end
        
        for i = 1,nCmpX do
            if not isequal(x[i], y[i]) then
                reason = string.format('different at', i, ':', x[i], y[i])

                return false, reason
            end
        end
        return true
    end
    
    
    if type_x == 'table' and not haveMaxN then  -- compare all elements of the table
        if #x ~= #y then
            reason = string.format('Different lengths : %d vs %d (\n %s \n   vs \n %s \n', #x, #y, tostring(x), tostring(y))
            return false, reason
        end
        --X = x;
        --Y = y
        local x_fields = table.keys(x)
        local y_fields = table.keys(y)
        
        local fieldsThatYdoesntHave = table.setdiff(x_fields,y_fields)
        local fieldsThatXdoesntHave = table.setdiff(y_fields,x_fields)
        
        if fieldsThatYdoesntHave or fieldsThatXdoesntHave then
            reason = '';
            if fieldsThatXdoesntHave then
                reason = reason .. string.format('x doesnt have these fields: %s; ', toList(fieldsThatXdoesntHave, nil, ', '))
            end
            if fieldsThatYdoesntHave then
                reason = reason .. string.format('y doesnt have these fields: %s; ', toList(fieldsThatYdoesntHave, nil, ', '))
            end
            return false, reason
        end
        
        
        for k,v in pairs(x) do
            local areEqual, reason = isequal(x[k], y[k])
            if not areEqual then
                if not reason then 
                    reason  = string.format('Field %s is different: \n%s\n  vs\n%s\n', tostring(k), tostring(x[k]):sub(1,150), tostring(y[k]):sub(1,150))
                end
                return false, reason
            end
                        
        end
        return true
    end
       
    error('Unsupported type : ' .. type_x)
    
end


torch.tensorsEqual = function(x,y)
    
    local x_size = x:size()
    local y_size = y:size()
    if (#x_size ~= #y_size) then
        return false
    end
    
    for i = 1,#x_size do
        if x_size[i] ~= y_size[i] then
            print(string.format('dim(%d): sz_x = %d. sz_y = %d\n', i, x_size[i], y_size[i]))
            return false
        end
    end

    
    if type(x[1]) == 'number' then  -- base case - tensors are just column vectors
        
        for i = 1,x:nElement() do  
            if x[i] ~= y[i] then
    --            print(string.format('(%d) %.1f ~= %.1f\n', i, x[i], y[i]))
                --print(i, x[i], y[i])
                return false
            end
        end
        
    else  -- have multi-dimensional tensors -- recursively check each sub-level
        
        for i = 1,x:size(1) do
            if not torch.tensorsEqual(x[i],y[i]) then
                return false;
            end
        end
        
    end
            
    return true
    --return torch.storagesEqual(x:storage(),y:storage(), x:nElement(), y:nElement())
        
end

torch.storagesEqual = function(x,y)
    local nx = #x
    local ny = #y
    
    if (nx ~= ny) then
        print(string.format('nx = %d. ny = %d\n', nx, ny))
        return false
    end
   
    for i = 1,nx do
        if x[i] ~= y[i] then
            print(string.format('(%d) %.1f ~= %.1f\n', i, x[i], y[i]))
            return false
        end
    end
    
    return true

end
        
        --[[
table.fieldsInAnotInB = function(a,b)
    local tbl_fieldNames = {}
    local count = 0
    for k,v in pairs(b) do
        if (a[k] == nil) then
            table.insert(tbl_fieldNames, k)
            count = count + 1
        end
    end
    if count > 0 then
        return tbl_fieldNames
    else
        return nil
    end
end

--]]