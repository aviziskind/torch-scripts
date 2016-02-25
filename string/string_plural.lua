string.plural = function(str)
    local add_es = false
    if ((#str >= 2) and table.anyEqualTo( string.sub(str, #str-1, #str), {'ch', 'sh'}) ) or
        ((#str >= 1) and table.anyEqualTo( string.sub(str, #str, #str), {'s', 'x', 'z'}) )  then
            add_es = true;
    end
    
    if add_es then
        return str .. 'es'
    else
        return str .. 's'
    end
    
end