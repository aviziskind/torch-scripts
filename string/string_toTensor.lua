string.toTensor = function(str)
    if type(str) ~= 'string' then
        error(string.format('Input was of type %s instead of string', type(str)))
    end
    
    return torch.Tensor( {string.byte( str, 1, #str)} ):reshape(#str, 1)
    
end

--[[ 
-- slow version
string.toTensor2 = function(s)
    local str_tensor = torch.DoubleTensor(#s, 1)
    for i = 1,#s do
        str_tensor[i] = string.byte(s,i,i)    
    end
    return str_tensor
end

--]]