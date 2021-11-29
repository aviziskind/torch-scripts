table.range = function(a,b, step)
    local tbl = {}
    
    step = step or 1
    
    local th = 1e-5 * step
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
    
    local wholeSteps = math.round(step) == step
    
    local curValue = a
    local i = 0
    while curValue <= b + th do
        if not wholeSteps then
            curValue = a + step*i
            --curValue = math.round( curValue / th ) * th -- round to nearest 
        end
        table.insert(tbl, curValue)
        curValue = curValue + step
        i = i + 1
    end
    
    
    return tbl
end