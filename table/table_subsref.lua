table.subsref = function(origTbl, idx_use)
    --O = origTbl
    --I = idx_use
    local newTbl = {}
    for i,idx in ipairs(idx_use) do
        if origTbl[idx] == nil then
            error(string.format('Original table has no entry for index: %d (table has %d entries)', idx, #origTbl))
        end
        table.insert(newTbl, origTbl[idx])
    end   
    return newTbl
end
