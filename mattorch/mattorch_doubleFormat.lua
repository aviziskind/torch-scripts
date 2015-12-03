require 'mattorch'

mattorch.doubleFormat = function(S)
    -- make a new table. every double-format variable in S is simply transferred (no memory copy).
    -- for non-double-format variables, a new (double format) version is created.
    --SS = S
    local S_double = {}
    for k,v in pairs(S) do
        if type(v) == 'number' then 
            S_double[k] = torch.DoubleTensor({v})
        elseif (torch.typename(v) == 'torch.DoubleTensor') then
            S_double[k] = S[k]
        elseif string.find(torch.typename(v), 'Tensor') then -- FloatTensor or ByteTensor, etc.
            S_double[k] = S[k]:double()
        else         
            error(string.format('Variable %s is not a tensor type (or a number)', k))
        end
    end

    return S_double

end