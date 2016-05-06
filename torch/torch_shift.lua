torch.shift = function(X, shiftAmounts, shiftDims)
    --[[
    local arg = {...}
    if #arg == 1 and type(arg) == 'table' then
        shiftDims = arg[1] 
    else
        shiftDims = arg
    end
    --]]
    Y = torch.Tensor(X:size()):zero()

    local nDims = X:nDimension()
    local idx_x = table.rep({}, nDims)
    local idx_y = table.rep({}, nDims)

    assert(type(shiftAmounts) == type(shiftDims))
    if type(shiftAmounts) == 'number' then
        shiftAmounts = {shiftAmounts}
        shiftDims = {shiftDims}
    elseif type(shiftAmounts) == 'table' then
        assert(#shiftAmounts == #shiftDims)
    end
       
    for i = 1,#shiftDims do
        local shiftDim = shiftDims[i]
        local shiftAmount = shiftAmounts[i]
        

        local dimSize = X:size(shiftDim);
        if math.abs(shiftAmount) >= dimSize then
            return Y
        end

        if shiftAmount >= 0 then       
            idx_x[shiftDim] = {1, dimSize-shiftAmount}
            idx_y[shiftDim] = {shiftAmount+1 , dimSize}
        elseif shiftAmount < 0 then
            idx_x[shiftDim] = {-shiftAmount+1 , dimSize}
            idx_y[shiftDim] = {1, dimSize+shiftAmount}
        end
    end

    Y[idx_y] = X[idx_x]
    return Y

end
