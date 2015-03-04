torch.nElements = function(t)
    -- this version of numel works even for CudaTensors
    local t_size = t:size()
    local nTot = 1
    for i = 1,#t_size do
        nTot = nTot * t_size[i]
    end
    return nTot
end