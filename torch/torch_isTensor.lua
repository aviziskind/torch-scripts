torch.isTensor = function(X)
    return (string.sub(getType(X), 1,5) == 'torch')
end