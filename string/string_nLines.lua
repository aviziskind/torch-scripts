string.nLines = function(str)
    local nLines = select(2, str:gsub('\n', '\n'))
    
    if (#str > 0) and not (string.sub(str, #str, #str) == '\n') then   -- if last line doesn't have a \n, add one more to count
        nLines = nLines + 1
    end
    return nLines
end
