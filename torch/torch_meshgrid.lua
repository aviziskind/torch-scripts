torch.meshgrid = function(x,y)
    
    nX = x:numel()
    nY = y:numel();
    xrow = x:reshape(1, nX)
    ycol = y:reshape(nY, 1);
    
    xx = torch.repeatTensor(xrow, ycol:size())
    yy = torch.repeatTensor(ycol, xrow:size())
    return xx, yy
end