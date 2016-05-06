table.plus = function(tbl, x)
    for i = 1,#tbl do
        if type(tbl[i]) == 'table' then
            tbl[i] = table.plus(tbl[i], x)
        else -- if type(tbl[i]) == 'number' then
            tbl[i] = tbl[i] + x
        end
    end
    return tbl
end