torch.tensorIterator = function(x)
    
    local nDims = x:nDimension()
    local sizeX = x:size()
    local idxs = torch.Tensor(nDims):fill(1)
    local storage = x:storage()
    local stride = x:stride()
    local nElementsInTensor = x:numel()
    local nElementsInStorage = #storage
    
    local storageOffset = x:storageOffset()
    
    return function()
    
        -- get index of current element
        local curStorageIdx = storageOffset
        for dim = 1,nDims do
            curStorageIdx = curStorageIdx + (idxs[dim] - 1)*stride[dim]
        end
        
        if curStorageIdx > nElementsInStorage then
            return 
        end
                
        local curElement = storage[curStorageIdx]
        
        -- increment the idxs appropriately along each dimension
        local dim = nDims
        idxs[dim] = idxs[dim]+1
        while (idxs[dim] > sizeX[dim]) and (dim > 1) do
            idxs[dim] = 1
            idxs[dim-1] = idxs[dim-1]+1
            dim = dim-1            
        end
        
        return curStorageIdx, curElement
        --print('idxs = ', idxs1[1], idxs1[2])
        
    end
    
    
end


-- example function that iterates (and prints all values in) a tensor
iterateOverTensor = function(X)
    for i,v in torch.tensorIterator(X) do 
        printf('%d : %.1f\n', i,v)
    end    
    
end
