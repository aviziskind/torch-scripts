isempty = function(X)
    local tp = getType(X)
    if (tp == 'table') or (tp == 'string')  then
        return (#X == 0)
    elseif (string.sub(tp,1,5) == 'torch') then
        return (X:numel() == 0)
    elseif (tp == nil) then
        return true
    else
        return false
    end      
end