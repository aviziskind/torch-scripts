table.toTensor = function(tbltbl, blankVal)
    blankVal = blankVal or 0
    local nSubTables = #tbltbl
    local maxSize = 0
    local curSize = 0
    for i,v in ipairs(tbltbl) do
        if type(v) == 'table' then
            curSize = #v
        elseif (type(v) == 'number') then
            curSize = 1
        end
            
        maxSize = math.max(maxSize, curSize)
    end
    
    local X
    if blankVal == 0 then
        X = torch.zeros(nSubTables, maxSize)
    else
        X = torch.ones(nSubTables, maxSize)*blankVal
    end
    for i,tbl_i in ipairs(tbltbl) do
        if (type(tbl_i) == 'table') then
            for j,val in ipairs(tbl_i) do
                X[i][j] = val
            end
        elseif (type(tbl_i) == 'number') then
            X[i][1] = tbl_i
        end
    end
    return X
end