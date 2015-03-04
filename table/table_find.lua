function table.find(tbl, item, k) -- , itemIsFuncFlag)
    
    if not item then
        item = function(x) return x ~= 0 end
    end    
    local itemIsFunction = type(item) == 'function' -- itemIsFuncFlag ~= nil
    
    local findMultipleItems = k ~= nil
    if k == 'all' then
        k = 1/0   -- =inf
    end

    
    
    local indices 
    if findMultipleItems then
        indices = {}
    end
    local nFound = 0
    for i,v in ipairs(tbl) do
        local foundItem
        if not item then
            foundItem = v ~= 0
        elseif item and itemIsFunction then
            foundItem = item(v)
        elseif item and not itemIsFunction then
            foundItem = v == item
        end
        
        if foundItem then
            
            if not findMultipleItems then
                return i
            else
                table.insert(indices, i)
                nFound = nFound + 1
                if nFound >= k then
                    break
                end
                
            end
            
           
        end
    end
    
    
    if findMultipleItems then
        return indices
    else
        return nil
    end
    
    
end
    


--]]