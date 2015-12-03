torch.tensorsEqual = function(x,y)
    X = x;
    Y = y;
    local x_size = x:size()
    local y_size = y:size()
    if (#x_size ~= #y_size) then
        return false
    end
    
    for i = 1,#x_size do
        if x_size[i] ~= y_size[i] then
            print(string.format('dim(%d): sz_x = %d. sz_y = %d\n', i, x_size[i], y_size[i]))
            return false
        end
    end

    if torch.numel(x) == 0 and torch.numel(y) == 0 then
        return true
    end
    
    if type(x[1]) == 'number' then  -- base case - tensors are just column vectors
        
        for i = 1,x:nElement() do  
            if x[i] ~= y[i] then
    --            print(string.format('(%d) %.1f ~= %.1f\n', i, x[i], y[i]))
                --print(i, x[i], y[i])
                return false
            end
        end
        
    else  -- have multi-dimensional tensors -- recursively check each sub-level
        
        for i = 1,x:size(1) do
            if not torch.tensorsEqual(x[i],y[i]) then
                return false;
            end
        end
        
    end
            
    return true
    --return torch.storagesEqual(x:storage(),y:storage(), x:nElement(), y:nElement())
        
end
