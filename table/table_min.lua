table.min = function(tbl)
    local minVal
    for i,v in ipairs(tbl) do
        if type(v) == 'number' then
            if not minVal then
                minVal = v
            else
                minVal = math.min(minVal, v)
            end
        end
    end
    return minVal
    
end
