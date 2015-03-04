totable = function(x)
    if type(x) == 'table' then
        return x
    else 
        return {x}
    end
end
