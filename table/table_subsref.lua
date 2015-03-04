table.subsref = function(origTbl, idx_use)
    local newTbl = {}
    for i,idx in ipairs(idx_use) do
        if origTbl[idx] == nil then
            error(string.format('Original table has no entry for index: %d', idx))
        end
        table.insert(newTbl, origTbl[idx])
    end   
    return newTbl
end
