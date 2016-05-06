torch.diff = function(x,n,dim)
    --idx = table.rep({}, x:nDimension())
    local sizeX = x:size()
    if not dim then
        dim = torch.find( torch.LongTensor(sizeX):gt(1), 1)
        if dim then
            dim = dim[1]
        else
            dim = 1
        end
    end
    
    local idx_tbl1 = table.rep({}, x:nDimension() )
    local idx_tbl2 = table.rep({}, x:nDimension() )
    
    local y = x
    n = n or 1
    for i = 1,n do
        local N = y:size(dim)
        if N > 1 then
            idx_tbl1[dim] = {2, N}
            idx_tbl2[dim] = {1, N-1}
            y = y[idx_tbl1]-y[idx_tbl2]
        end
        -- should also handle case when N == 1 (return empty tensor)
    
    end
    return y

    
    --return x[{{2, N}}]-x[{{1,N-1}}]
    
end