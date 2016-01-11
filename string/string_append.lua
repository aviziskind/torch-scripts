function string.append(curStr, newStr, sep)
    sep = sep or '_' 
    
    if curStr == '' then
        return newStr
    elseif newStr == '' then
        return curStr
    else
        return curStr .. sep .. newStr
    end

end
 