
expandOptionsToList = function(allOptions, loopKeysOrder)
    --print(allOptions)
    local baseTable = {}
    local loopKeys = {}
    local loopKeys_full = {}
    local loopValues = {}
    local nValuesEachLoopKey = {}
    local nTablesTotal = 1
    
    -- find which variables are to be looped over, and gather in a separate table
    for key_full,val in pairs(allOptions) do
        if string.sub(key_full, 1, 4) == 'tbl_' then
            local key = string.sub(key_full, 5, #key_full)
            
            table.insert(loopKeys_full, key_full)
            table.insert(loopKeys, key)
            
            --loopValues[keyName] = v
            if #val == 0 then
                print('val', val)
                print('options', allOptions)
                
                error(string.format('Key %s has 0 array entries\n', key))
            end
            
            
            table.insert(nValuesEachLoopKey, #val)
            nTablesTotal = nTablesTotal * (#val)
        else
            baseTable[key_full] = val
        end        
    end
    
    
    if loopKeysOrder then
        if type(loopKeysOrder) == 'string' then
            loopKeysOrder = {loopKeysOrder}
        end
        local idx_loopKeys_setOrder = {}
        for i,key in ipairs(loopKeysOrder) do
            local idx = table.find(loopKeys, key)
            if not idx then   error(string.format('No such field %s in table', key))  end
            idx_loopKeys_setOrder[i] = idx
        end
         
         local loopKeys_other_idxs = table.setdiff(table.range(1, #loopKeys), idx_loopKeys_setOrder)         
         --print('other=', loopKeys_other_idxs)
         local idx_new_order = table.merge(idx_loopKeys_setOrder, loopKeys_other_idxs)
                 
         loopKeys_full = table.subsref(loopKeys_full, idx_new_order)
         loopKeys = table.subsref(loopKeys, idx_new_order)
         nValuesEachLoopKey = table.subsref(nValuesEachLoopKey, idx_new_order)
        
            --print(loopKeys)
            --return;
    end
    
    -- initialize loop variables
    local nLoopFields = #nValuesEachLoopKey
    local loopIndices = {}
    for i = 1, nLoopFields do
        loopIndices[i] = 1
    end
    
    -- loop over all the loop-variables, assign to table.

    local allTables = {}
    for j = 1, nTablesTotal do
        local tbl_i = table.copy(baseTable)
        
        table.insert(allTables, tbl_i)
        
        if #loopIndices == 0 then
            break
        end
        
        for i = 1, nLoopFields do
            
            if type(allOptions[loopKeys_full[i]]) ~= 'table' then
                error(string.format('Field %s is not a table', loopKeys_full[i]))
            end
            local vals_field_i = table.copy( allOptions[loopKeys_full[i]] )
            
            if not string.find(loopKeys[i], '_and_') then
            
                tbl_i[loopKeys[i]] = vals_field_i[loopIndices[i]]
            else
                local sub_fields = {}
                for sub_fld in string.gmatch(string.gsub(loopKeys[i], '_and_', ','), "%a+") do 
                    table.insert(sub_fields, sub_fld)
                end                
                
                for k = 1,#sub_fields do
                    tbl_i[sub_fields[k]] = vals_field_i[loopIndices[i]][k];
                end
            end
        end
        
        local curFldIdx = 1
        
        loopIndices[curFldIdx] = loopIndices[curFldIdx] + 1
        while loopIndices[curFldIdx] > nValuesEachLoopKey[curFldIdx] do
            loopIndices[curFldIdx] = 1
            curFldIdx = curFldIdx + 1
            
            if curFldIdx > nLoopFields then
                assert(j == nTablesTotal)
                break;
            end
            loopIndices[curFldIdx] = loopIndices[curFldIdx]+1
        end
        
    end
    
    return allTables
    
end


testExpandOptionsToList = function()
    options_test = { netType = 'ConvNet', 
               poolStrides = 2,
               tbl_doPooling = {false, true},
               tbl_allNStates = { 1, 2 },
               --tbl_allNStates_and_test = { { 1 , 'B'}, {2, 'C'}  },
               tbl_filtsizes = { {6, 16}, {12, 32} }
               }

    list_test = expandOptionsToList(options_test)
    
    print('Initial options table');
    print(options_test)
    
    print('\n\nFinal list of tables:');
    for i,v in ipairs(list_test) do
        print(string.format('-- Table #%d --', i))
        print(v)
    end
    
end
