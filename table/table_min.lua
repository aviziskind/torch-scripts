table.min = function(tbl)
    local minVal, indMin
    for i,v in ipairs(tbl) do
        if type(v) == 'number' and (not minVal or v < minVal) then
            minVal = v
            indMin = i
        end
    end
    return minVal, indMin
    
end


