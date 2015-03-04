torch.StorageOfType = function(arg, storageType)
    
    storageType = string.gsub(storageType, 'torch.', '')
    storageType = string.gsub(storageType, 'Storage', '')
    
    if storageType == 'Byte' then
        return torch.ByteStorage(arg)
        
    elseif storageType == 'Char' then
        return torch.CharStorage(arg)
        
    elseif storageType == 'Short' then
        return torch.ShortStorage(arg)
        
    elseif storageType == 'Int' then
        return torch.IntStorage(arg)
        
    elseif storageType == 'Long' then
        return torch.LongStorage(arg)
        
    elseif storageType == 'Float' then
        return torch.FloatStorage(arg)
        
    elseif storageType == 'Double' then
        return torch.DoubleStorage(arg)
        
        
    elseif storageType == 'Cuda' then
        return torch.CudaStorage(arg)
    
    else
        error(string.format('Unknown storage type : %s', storageType))
    end
       
    
end


