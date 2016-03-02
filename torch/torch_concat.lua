torch.concat = function(...)
    -- concatenates numbers (or tables of numbers) and storages into a torch.Storage (or a torch.Tensor if any inputs are tensors)
    -- recursively goes through tables.
    -- uses a torch.LongStorage unless there are any fractions (or 
    
    local arg = {...}
    if #arg == 1 and type(arg[1]) == 'table' then
        arg = arg[1]
    end
    
    
    local nTotal = 0
    local F = {}
    
    F.totalNumberOfElements = function(X)
        if type(X) == 'number' then
            return 1
        elseif torch.isTensor(X) then
            return X:numel()
        elseif torch.isStorage(X) then
            return X:size()
        elseif type(X) == 'table' then
            local total = 0
            for j,v in ipairs(X) do
                total = total + F.totalNumberOfElements(v)
            end
            return total
        end
    end
    
    nTotal = F.totalNumberOfElements(arg)
    
    
    
    
    
    local outputClass = 'Storage'
    local outputType  = 'Long'
    
    F.getClassAndType = function(X)
        
        if type(X) == 'number' then
            if X ~= math.floor(X) and not (outputType == 'Double') then
                outputType = 'Float'
            end
            
        elseif torch.isTensor(X) then
            outputClass = 'Tensor'
            if X:type() == 'torch.DoubleTensor' then
                outputType = 'Double'
            elseif X:type() == 'torch.FloatTensor' and not (outputType == 'Double') then
                outputType = 'Float'
            end
            
        elseif torch.isStorage(X) then
            if torch.typename(X) == 'torch.DoubleStorage' then
                outputType = 'Double'
            elseif torch.typename(X) == 'torch.FloatStorage' and not outputType == 'Double' then
                outputType = 'Float'
            end                 
           
        elseif type(X) == 'table' then            
            for j,v in ipairs(X) do
                F.getClassAndType(v)
            end
        else
             error('Inputs must be all tensors or storages (or numbers or tables)')
        end
    end
    
    F.getClassAndType(arg)
    
    
    
    
    local Y
    if outputClass == 'Tensor' then
        Y = torch.Tensor(nTotal):type('torch.' .. outputType .. 'Tensor')
    elseif outputClass == 'Storage' then
        Y = torch.StorageOfType(nTotal, outputType)
    end
    


    local idx = 1
    F.addElementsToY = function(X)
        
        if type(X) == 'number' then
            Y[idx] = X
            idx = idx + 1     
        elseif torch.isTensor(X) then
            for i,v in torch.tensorIterator(X) do 
                Y[idx] = v
                idx = idx + 1
            end   
        elseif torch.isStorage(X) then
             for j = 1,#X do
                Y[idx] = X[j]
                idx = idx + 1
            end
        elseif type(X) == 'table' then -- recurse
            for j,v in ipairs(X) do
                F.addElementsToY(v)
            end
        end
    end
    
    F.addElementsToY(arg)
        
        
    return Y
        
end