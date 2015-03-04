table.length = function(tbl)
    local n = 0
    for k,v in pairs(tbl) do
        n = n +1
    end
    return n
end