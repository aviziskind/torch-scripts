math.sign = function(x)
    if type(x) ~= 'number' then
        error('Expected a number')
    end
        
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    elseif x == 0 then
        return 0
    end
end