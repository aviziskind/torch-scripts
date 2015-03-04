string.findAll = function(s_orig, pat)
    local tbl_start = {}
    local tbl_end = {}
    local s = s_orig
    local offset = 0
    
    local idx_start, idx_end = string.find(s, pat)
    while idx_start do
        table.insert(tbl_start, offset + idx_start)
        table.insert(tbl_end,   offset + idx_end)
        
        s = string.sub(s, idx_end+1, #s)
        offset = offset + idx_end
        idx_start, idx_end = string.find(s, pat)
    end
    
    ---[[
    --check:
    for i = 1,#tbl_start do
        assert(string.sub(s_orig, tbl_start[i], tbl_end[i]) == pat)
        --print(string.sub(s_orig, tbl_start[i], tbl_end[i]))
    end
    --]]
    
    return tbl_start, tbl_end
end