
abbrevList = function(X, sep, maxRunBeforeAbbrev)
    --[[
    concatenates non-sequential items into a list
        1,4,9 -->1_4_9
    
    abbreviates sequences (containing at least 3 elements):
        1,2,3,4,5         --> 1t5     -- like MATLAB's  1:5
        1,3,5,7,9         --> 1t2t9   -- like MATLAB's  1:2:9
        1,1.5,2,2.5,3     --> 1h3     -- "h" = special separator for steps of 0.5  (*h*alf)
        1,1.25,1.5,1.75,2 --> 1q2     -- "q" = special separator for steps of 0.25 (*q*uarter) 
        0,5,10,15,20      --> 0f20    -- "f" = special separator for steps of 5    (*f*ive)
        0,10,20,30,40     --> 0d40    -- "d" = special separator for steps of 10   (*d*ecade)
            
    abbreviates repeated elements
        1,1,1,1  --> 1r4        -- like a special separator for steps of 0
    
    combines mixes of sequences:
        1,2,3,4, 8,8.5,9, 15,15,15, 20  --> 1t4_8h9_15r3_20
    
    --]]
    
    
    sep  = sep or '_'
    maxRunBeforeAbbrev = maxRunBeforeAbbrev or 2
    if maxRunBeforeAbbrev < 0 then
        maxRunBeforeAbbrev = 1e10
    end
    
    local abbrevSepValues = {[1] = 't', [0.5] = 'h', [0.25] = 'q', [5] = 'f', [10] = 'd'}

    local useHforHalfValues = true
    
    local typeX = getType(X)
    local str = ''
    
    
    
    if typeX == 'table' then
        if #X == 0 then
            return ''
        end
        local L = #X;
        --maxN = math.min(maxN or #X, #X)
        
        local X_str = table.apply(tostring, X)
        local curIdx = 1
        str = X_str[1]
        while curIdx < L do  -- maxN
            local runLength = 0
            local initDiff = X[curIdx+1] - X[curIdx]
            local curDiff = initDiff
            while (curIdx+runLength < L) and (curDiff == initDiff) do
                runLength = runLength + 1
                if curIdx+runLength < L then
                    curDiff = X[curIdx+runLength+1] - X[curIdx+runLength]
                end
            end
            --print('run = ', runLength)
            if runLength >= maxRunBeforeAbbrev then
                --print('a');
                --print( 't' .. X[curIdx+runLength] )
                if initDiff == 0 then
                    str = str .. 'r' .. runLength+1
                    
                else
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
                    
                    str = str .. abbrevSep .. X_str[curIdx+runLength]
                    
                end
                curIdx = curIdx + runLength+1
            else
                --print('b');
                --print( table.concat(X, sep, curIdx, curIdx+runLength) )
                if (runLength > 0) then 
                    str = str .. sep .. table.concat(X_str, sep, curIdx+1, curIdx+runLength)
                end 
                curIdx = curIdx + runLength+1
            end       
            if curIdx <= L then
                str = str .. sep .. X_str[curIdx]
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
