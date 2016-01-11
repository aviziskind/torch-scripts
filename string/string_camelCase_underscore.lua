
string.underscore2camelCase = function(str)
    
    
    local lower, upper
    local lower_offset = string.byte('a')-1
    local upper_offset = string.byte('A')-1
    
    for i = 1, 26 do
        lower = string.char(lower_offset + i)
        upper = string.char(upper_offset + i)
        --print(i, lower, upper)
    
        str = string.gsub(str, '_' .. lower, upper)
    end
    
    return str
end

string.camelCase2underscore = function(str)
    
    -- partDetector --> part_detector
    -- PartDetector --> Part_detector
    
    local lower, upper
    local lower_offset = string.byte('a')-1
    local upper_offset = string.byte('A')-1
    
    for i = 1, 26 do
        lower = string.char(lower_offset + i)
        upper = string.char(upper_offset + i)
    
        str = string.gsub(str, upper, '_' .. lower )
    end
    
    -- handle case where first character is upper-case: put back to how it was, dont change to underscore:
    if string.sub(str, 1,1) == '_' then
        str = string.upper(string.sub(str, 2,2)) .. string.sub(str, 3,#str)
    end
    
    return str
    
end
