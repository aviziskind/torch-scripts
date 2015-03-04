string.toTensor = function(str)
    return torch.Tensor( {string.byte( str, 1, #str)} )
end
