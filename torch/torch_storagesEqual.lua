torch.storagesEqual = function(x,y)
    local nx = #x
    local ny = #y
    
    if (nx ~= ny) then
        print(string.format('nx = %d. ny = %d\n', nx, ny))
        return false
    end
   
    for i = 1,nx do
        if x[i] ~= y[i] then
            print(string.format('(%d) %.1f ~= %.1f\n', i, x[i], y[i]))
            return false
        end
    end
    
    return true

end
        