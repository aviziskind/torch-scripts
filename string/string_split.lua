string.split = function(str, sep)

    if not sep then
        sep = "%s"
    end
    
    local tbl = {}
    for token in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(tbl, token)
    end
    return tbl
    
end
    

--[[

strings2table = function(str)
    -- takes a multi-line string, and puts each line as a separate entry in a table
    str_copy = str
    n = 1
    str_sub = str
    tbl = {}
    while true do
        idx_newline = string.find(str_sub, '\n')
        if idx_newline then
            idx_end = idx_newline-1
        else
            idx_end = #str_sub
        end
            
        table.insert(tbl, string.sub(str_sub, 1, idx_end) )
        if idx_end == #str_sub then
            break
        end
        str_sub = string.sub(str_sub, idx_newline+1, #str_sub)
    end
    return tbl
        
end

--]]
