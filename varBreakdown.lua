varBreakdown = function(X)
    addPct = true

    if X:numel() == 0 then
        return
    end
        
    --local uniqueVals, ns 
    if torch.isTensor(X) then
        uniqueVals, ns = torch.uniqueCount(X);
        
                
    elseif type(X) == 'table' then  -- must be a cell array of strings. 
        --[[
        X = cellfun(@num2str, X, 'un', 0); -- just in case some of them not strings, or empty.            
        [uniqueVals, ns] = uniqueCount(X);
        ns_num = ns;
        ns = num2cell(ns(:));
        vals = uniqueVals(:);
        --]]
    end
    
    ns_log10 = ns:log() / torch.log(10)
    maxLengthN = math.ceil( ns_log10:max() )
    printf('       N              Values\n');
    printf('  ------------    ----------------\n')
    str_num = ' %' .. tostring(maxLengthN) .. 'd'
    for i = 1, ns:numel() do
        if not addPct then
            printf(str_num .. '   :  %s \n', ns[i], tostring(uniqueVals[i])); 
        else
            printf(str_num .. ' (%4.1f%%)   :  %s \n', ns[i], ns[i]/ns:sum()*100, tostring(uniqueVals[i])); 
        end
    end

end
