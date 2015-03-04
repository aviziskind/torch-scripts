fileOlderThan = function(file1, file2, errorIfNotPresent)
        
    assert(file1 and file2)
    
    local datenum1
    if type(file1) == 'string' then
        local attrib1 = lfs.attributes(file1)
        if not attrib1 then
            if errorIfNotPresent then
                error(string.format('File %s not found', file1))
            else
                return false
            end
        end
        datenum1 = attrib1.modification
    elseif type(file1) == 'number' then
        datenum1 = file1
    end
        
    local datenum2
    if type(file2) == 'string' then
        local attrib2 = lfs.attributes(file2)
        if not attrib2 then
            if errorIfNotPresent then
                error(string.format('File %s not found', file2))
            else
                return false
            end
        end
        datenum2 = attrib2.modification
    elseif type(file2) == 'number' then
        datenum2 = file2;
    end
    
    return (datenum1 < datenum2), datenum1, datenum2
    
end
