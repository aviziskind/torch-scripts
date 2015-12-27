require 'mattorch'

mattorch.saveChk = function(matFile, S)
    -- Checks for 3 things that can cause the mattorch.save function to fail:   
    -- 1) All variables must be double tensors (causes a fail)
    -- 2) All double tensors must be < 2GB in size (causes a crash if larger)
    -- 3) Checks that the destination folder exists (causes a crash if doesnt exist)
    
    local nBytesMax = 0
    if type(S) == 'table' then
        for k,v in pairs(S) do
            if not torch.typename(v) == 'torch.DoubleTensor' then
               error(string.format('Variable %s is not a Double Tensor\n', k))
            end
            nBytesMax = math.max(nBytesMax, v:numel()*8)
        end
    elseif torch.typename(S) == 'torch.DoubleTensor' then
        nBytesMax = S:numel()*8 
    end
    
    local nBytesMaxLimit = 2*1024^3;
    if nBytesMax >= nBytesMaxLimit then
        error(string.format('Cannot save mat files with variables more than 2GB in size (have one that is %.2f GB)', nBytesMax/(1024^3)))
    end
    
    verifyFolderExists(matFile)
    
    mattorch.save(matFile, S)
    
end