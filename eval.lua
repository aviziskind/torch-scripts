eval = function (str)    
    return assert( loadstring("return " .. str )() )
end