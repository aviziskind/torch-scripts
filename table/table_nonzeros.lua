table.nonzeros = function(tbl)
    return table.subsref(tbl, table.find(tbl, nil, 'all'))
end
