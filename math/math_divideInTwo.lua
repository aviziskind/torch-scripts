math.splitInTwo = function(x)
    --local a = math.ceil(x/2)
    local a = math.floor(x/2)
    local b = x - a 
    
    return a, b
end