string.burst = function(str)
    local tbl = {}
    for i = 1,#str do
        tbl[i] = string.sub(str, i, i)
    end
    return tbl
end
