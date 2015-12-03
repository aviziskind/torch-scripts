strcmp_helper = function(s1, s2, maxN, ignoreCase)
    if not s1 then
        error('Missing first string argument')
    end
    if not s2 then
        error('Missing second string argument')
    end
    local compare_two_strings = function(s1, s2)
        
        if maxN then
            s1 = string.sub(s1, 1, maxN)
            s2 = string.sub(s2, 1, maxN)
        end
        if ignoreCase then
            s1 = string.lower(s1)
            s2 = string.lower(s2)
        end
        
        --io.write(string.format('[%s, %s]', tostring(maxN), tostring(ignoreCase)))
        --io.write(string.format('["%s" vs "%s"]\n', s1, s2))
        return s1 == s2

    end

    local compare_stringTable_with_strings = function(strs, s)
        local results = {}
        for i = 1,#strs do
            results[i] = compare_two_strings(strs[i], s)
        end
        return results
    end
    
    local compare_two_stringTables = function(strs1, strs2)
        local results = {}
        for i = 1,#strs1 do
            results[i] = compare_two_strings(strs1[i], strs2[i])
        end
        return results        
        
    end
  
  
    local type1 = type(s1)
    local type2 = type(s2)
    
    if type1 == 'string' and type2 == 'string' then
        return compare_two_strings(s1, s2)
    
    elseif type1 == 'table' and type2 == 'table' then
        if not (#s1 == 1 or #s2 == 1 or #s1 == #s2) then
            error('One of the inputs must be a single string, or both tables must be the same length')
        end
        return compare_two_stringTables(s1, s2)
    
    elseif type1 == 'table' and type2 == 'string' then
        return compare_stringTable_with_strings(s1, s2)
        
    elseif type1 == 'string' and type2 == 'table' then
        return compare_stringTable_with_strings(s2, s1)
        
    else
        error('Must provide two strings, one string and one table of strings, or two tables of strings of equal length')
    end
        
end



strcmp = function(s1, s2)
    return strcmp_helper(s1, s2)
end

strncmp = function(s1, s2, n)
    if not n then
        error('Missing third argument (n)')
    end
    return strcmp_helper(s1, s2, n)
end

strcmpi = function(s1, s2)
    return strcmp_helper(s1, s2, nil, true)
end

strncmpi = function(s1, s2, n)
    if not n then
        error('Missing third argument (n)')
    end
    
    return strcmp_helper(s1, s2, n, true)
end