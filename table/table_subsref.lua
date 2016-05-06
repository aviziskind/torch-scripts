table.subsref = function(origTbl, idx_use)
    --O = origTbl
    --I = idx_use
    -- check idx_use - either a list of indices or booleans 
    local newTbl = {}
    
    if #idx_use == 0 then
        return
    end
    
    local is_numeric = type(idx_use[1]) == 'number'
    local is_bool    = type(idx_use[1]) == 'boolean'

    local checkIdxs = true
    if checkIdxs then
        for i,v in ipairs(idx_use) do
            if (is_numeric and type(v) ~= 'number') or 
                (is_bool and type(v) ~= 'boolean') then
                    error('Mismatch in indexing table - must be all numbers or all booleans')
            end
           
        end        
    end
    
    if is_numeric then
        for i,idx in ipairs(idx_use) do
            if origTbl[idx] == nil then
                error(string.format('Original table has no entry for index: %d (table has %d entries)', idx, #origTbl))
            end
            table.insert(newTbl, origTbl[idx])
        end   
    elseif is_bool then
        for idx,tf in ipairs(idx_use) do
            if origTbl[idx] == nil then
                error(string.format('Original table has no entry for index: %d (table has %d entries)', idx, #origTbl))
            end
            if tf then 
                table.insert(newTbl, origTbl[idx])
            end
        end   
    end
        
        
    return newTbl
end
