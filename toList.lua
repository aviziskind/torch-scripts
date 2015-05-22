
toList = function(X, sep)
    
    return toTruncList(X, nil, sep);
    
end



toTruncList = function(X, maxN, sep)
    local typeX = getType(X)
    sep  = sep or '_'
    
    if typeX == 'table' then
        if #X == 0 then
            return ''
        end
        maxN = math.min(maxN or #X, #X)
        return table.concat(X, sep, 1, maxN)
        
    elseif typeX == 'number' then
        return tostring(X)
        
    --elseif string.find(typeX, 'Tensor') then
        
    elseif string.find(typeX, 'Storage') then
        
        maxN = math.min(maxN or #X, #X)
        local s = tostring(X[1])
        for i = 2, maxN do
            s = s .. sep .. tostring(X[i])
        end

        return s
    end
    error('Unhandled case type(X) = ' ..  typeX)
    
end
