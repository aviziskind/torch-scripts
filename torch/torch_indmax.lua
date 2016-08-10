torch.indmax = function(X)
    local mxVal = torch.max(X)

    local indMax = X:view(-1):eq(mxVal):nonzero()[1][1]

    local h = X:size(1)
    local w = X:size(2)
    
    local i = math.ceil(indMax / w)
    local j = indMax - w*(i-1) 
    
    
--[[    
    i = math.floor(indx/h)
    j = indx - i*h - 
    
    
    h = 3    
    w = 5
    
    indx = i*h + j
    
    1  2  3  4  5
    6  7  8  9  10
    11 12 13 14 15
--]]
    return torch.LongStorage({i,j}), mxVal



end




