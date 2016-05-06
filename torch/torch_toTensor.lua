torch.toTensor = function(x)
    if torch.isTensor(x) then
        return x
    end
   
    if type(x) == 'table' then
        return table.toTensor(x)
    end
    
    if type(x) == 'number' then
        return torch.Tensor({x})
    end
    
    if torch.isStorage(x) then
        return torch.Tensor(   torch.Storage(#x):copy(x) )
    end
    
    error('Unhandled case')
end