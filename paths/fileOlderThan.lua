paths.fileOlderThan = function(file1, file2, errorIfNotPresent)
        
    assert(file1 and file2)
    
    local datenum1
    if type(file1) == 'string' then
        local file1Present = paths.filep(file1)
        if not file1Present then
            if errorIfNotPresent then
                error(string.format('File %s not found', file1))
            else
                return false
            end
        end
        datenum1 = paths.filedate( file1 )
        
    elseif type(file1) == 'number' then
        datenum1 = file1
    end
    
    
    
    local datenum2
    if type(file2) == 'string' then
        
        local file2Present = paths.filep(file2)
        if not file2Present then
            if errorIfNotPresent then
                error(string.format('File %s not found', file2))
            else
                return false
            end
        end
        datenum2 = paths.filedate( file2 )
    
    elseif type(file2) == 'number' then
        datenum2 = file2;
    end
    
    
    return (datenum1 < datenum2), datenum1, datenum2
    
end
