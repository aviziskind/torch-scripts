table.max = function(tbl)
    local maxVal
    for i,v in ipairs(tbl) do
        if type(v) == 'number' then
            if not maxVal then
                maxVal = v
            else
                maxVal = math.max(maxVal, v)
            end
        end
    end
    return maxVal
    
end

