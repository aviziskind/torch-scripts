torch.meshgrid = function(x,y)
    
    local nX = x:numel()
    local nY = y:numel();
    local xrow = x:reshape(1, nX)
    local ycol = y:reshape(nY, 1);
    
    local xx = torch.repeatTensor(xrow, ycol:size())
    local yy = torch.repeatTensor(ycol, xrow:size())
    return xx, yy
end