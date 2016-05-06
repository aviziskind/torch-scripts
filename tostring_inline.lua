function tostring_inline(x, fmt)
    
    local typeX = type(x)
    local torchTypeX = torch.typename(x)
    if torchTypeX then
        typeX = torchTypeX
    end
    
    if typeX == 'table' then
        
        local isArray = table.isArray(x)
        
        local s = '{'
        
        if isArray then 
            for i,v in ipairs(x) do    
                s = s .. tostring_inline(v, fmt) .. ', '
            end
        else
            for k,v in pairs(x) do    
                s = s .. k .. '=' .. tostring_inline(v, fmt) .. ', '
            end
        end
        s = string.sub(s, 1, #s-2) .. '}'
            
        return s
                
    elseif typeX == 'string' then
        return '"' .. x .. '"'
        
    elseif typeX == 'number' or typeX == 'boolean' then
        if fmt then
            return string.format(fmt, x)
        else
            return tostring(x)
        end
    elseif typeX == 'nil' then
        return tostring(x)
        
    elseif torchTypeX then
    
        assert (string.sub(typeX, 1, 6) == 'torch.')
        
        if string.find(typeX, 'Storage') then
            local s = '['
            for i = 1,#x do    
                s = s .. x[i] .. ', '
            end
            s = string.sub(s, 1, #s-2) .. ']'
            return s
        elseif string.find(typeX, 'Tensor') then
        
            local nDims = x:nDimension()
            local s = '['
            
            if nDims == 1 then
                for i = 1,x:numel() do    
                    s = s .. tostring_inline(x[i], fmt) .. ', '
                end               
            elseif nDims == 2 then
                for i = 1,x:size(1) do    
                    s = s .. '[' 
                    for j = 1,x:size(2) do
                        s = s .. tostring_inline(x[i][j], fmt) .. ', '
                    end
                    s = string.sub(s, 1, #s-2) .. '], '
                end               
            
            end
                        
            s = string.sub(s, 1, #s-2) .. ']'
            return s

        end
        
    
    else --typeX == 'userdata' then
                
        error(string.format('Unhandled type : ', typeX))
        
    end

    
    
end
