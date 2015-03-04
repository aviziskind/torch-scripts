string.titleCase = function(str)
        
    local function tchelper(first, rest)
        return first:upper()..rest:lower()
    end
    
    -- Add extra characters to the pattern if you need to. _ and ' are
    --  found in the middle of identifiers and English words.
    -- We must also put %w_' into [%w_'] to make it handle normal stuff
    -- and extra stuff the same.
    -- This also turns hex numbers into, eg. 0Xa7d4
    return str:gsub("(%a)([%w_']*)", tchelper)
    
end


