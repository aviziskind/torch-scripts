table.toSymtable = function(X)
    local symTable = {}
    for k,v in pairs(X) do
        symTable[v] = k
    end
    return symTable
end
