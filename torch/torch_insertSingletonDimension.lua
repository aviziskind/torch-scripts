function torch.insertSingletonDimension(X, dimInsert)
    local curSize = X:size()
    local nDimensions = X:nDimension()
    local newSize = torch.LongStorage(#curSize + 1)
    if dimInsert > nDimensions then 
        error('singleDimensionToInsert > nCurrentDimensions')
    end
    
    for j = 1,dimInsert-1 do
       newSize[j] = curSize[j] 
    end
    
    newSize[dimInsert] = 1   --   <-- add the singleton dimension!
    
    for j = dimInsert,nDimensions do
        newSize[j+1] = curSize[j]
    end
    
    return X:resize(newSize)

end