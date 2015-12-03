table.nUnique = function(x)
    if type(x) == 'number' then
        x = {x}
    end
    local nU = 0
    
    for i = 1,#x do
        local found_i = false
        for j = i+1,#x do
            if isequal(x[i], x[j]) then
                found_i = true
                break
            end
        end
        if not found_i then
            nU = nU+1
        end
    end
    return nU
    
end
