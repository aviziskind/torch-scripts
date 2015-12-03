table.max = function(tbl)
    local maxVal, indMax
    for i,v in ipairs(tbl) do
        if type(v) == 'number' and (not maxVal or v > maxVal) then
            maxVal = v
            indMax = i
        end
    end
    return maxVal, indMax
    
end

