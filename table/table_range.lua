table.range = function(a,b, step)
    local tbl = {}
    
    step = step or 1
    
    assert( step > 0 )
    --[[
    if math.sign(d) ~= math.sign(b-a) then
        error('Must have positive step for positive range')
    end
    --]]
    
    --[[
    local n = math.floor( (b-a+1)/d ) -1
    for i = 1,n do
        tbl[i] = a+(i-1)*d
    end
    --]]
    
    local curValue = a
    while curValue <= b do
        table.insert(tbl, curValue)
        curValue = curValue + step
    end
    
    
    return tbl
end