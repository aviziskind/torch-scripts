table.sorted = function(tbl)
    local tbl_new = table.copy(tbl)
    table.sort(tbl_new)
    return tbl_new

end