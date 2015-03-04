table.rep = function(x, n, dontNestFlag)
    local tbl = {}
    for i = 1,n do
        if dontNestFlag and type(x) == 'table' then
            for j = 1,#x do
                table.insert(tbl, x[j])
            end
        else
            table.insert(tbl, x)
        end
    end
    return tbl
end
