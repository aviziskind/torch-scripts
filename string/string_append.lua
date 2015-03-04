function string.append(curStr, newStr, sep)
    if not sep then
        sep = '; ';
    end
    
    if curStr == '' then
        return newStr
    elseif newStr == '' then
        return curStr
    else
        return curStr .. sep .. newStr
    end

end
 