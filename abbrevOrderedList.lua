
abbrevOrderedList = function(X, maxN, sep, maxRunBeforeAbbrev)
    
    sep  = sep or '_'
    maxRunBeforeAbbrev = maxRunBeforeAbbrev or 2
    
    local abbrevSepValues = {[1] = 't', [0.5] = 'h', [0.25] = 'q', [5] = 'f', [10] = 'd'}

    local useHforHalfValues = true
    
    local typeX = getType(X)
    local str = ''
    
    if typeX == 'table' then
        if #X == 0 then
            return ''
        end
        maxN = math.min(maxN or #X, #X)
        
        
        local curIdx = 1
        str = tostring(X[1])
        while curIdx < maxN do
            local runLength = 0
            local initDiff = X[curIdx+1] - X[curIdx]
            local curDiff = initDiff
            while (curIdx+runLength < maxN) and (curDiff == initDiff) do
                runLength = runLength + 1
                if curIdx+runLength < maxN then
                    curDiff = X[curIdx+runLength+1] - X[curIdx+runLength]
                end
            end
            --print('run = ', runLength)
            if runLength >= maxRunBeforeAbbrev then
                --print('a');
                --print( 't' .. X[curIdx+runLength] )
                local abbrevSep
                for diffVal,diffSymbol in pairs(abbrevSepValues) do
                    
                    if initDiff == diffVal then
                        abbrevSep = diffSymbol
                    end
                end
                if not abbrevSep then
                    --print(initDiff)
                    abbrevSep = string.format('t%st', tostring(initDiff))
                end
                
                str = str .. abbrevSep .. tostring(X[curIdx+runLength])
                curIdx = curIdx + runLength+1
            else
                --print('b');
                --print( table.concat(X, sep, curIdx, curIdx+runLength) )
                if (runLength > 0) then 
                    str = str .. sep .. table.concat(X, sep, curIdx+1, curIdx+runLength)
                end 
                curIdx = curIdx + runLength+1
            end       
            if curIdx <= maxN then
                str = str .. sep .. tostring(X[curIdx])
            end
        end        
        
    elseif typeX == 'number' then
        str = tostring(X)
    else
        error('Unhandled case type(X) = ' ..  typeX)
    end
    
    str = string.gsub(str, '-', 'n')        
    
    if useHforHalfValues then
        str = string.gsub(str, '%.5', 'H')
    end
    
    return str
end
