torch.unique = function(a)
    local sortA, indSortA = torch.sort(a:view(-1))
           
    local numelA = a:numel()
    
    ---- groupsSortA indicates the location of non-matching entries.
    local dSortA = torch.diff(sortA);
    local groupsSortA
    if (isnan(dSortA[1]) or isnan(dSortA[numelA-1])) then
        groupsSortA = sortA[{{1, numelA-1}}]:ne (  sortA[{{2, numelA}}]  )
    else
        groupsSortA = dSortA:ne(0)
    end
        
    if (numelA ~= 0) then
        groupsSortA = torch.concat(1, groupsSortA):byte();          -- First element is always a member of unique list.
    else
        groupsSortA = torch.zeros(0,1)
    end
    
    ---- Extract unique elements.
    --if strcmp(order, 'stable') 
        --invIndSortA = indSortA;
        --invIndSortA(invIndSortA) = 1:numelA;  -- Find inverse permutation.
        --logIndA = groupsSortA(invIndSortA);   -- Create new logical by indexing into groupsSortA.
        --c = a(logIndA);                       -- Create unique list by indexing into unsorted a.
    --else
        c = sortA:index( 1, groupsSortA:nonzero():view(-1) );         -- Create unique list by indexing into sorted list.
    --end
    
    -- Find indA.
    --if nargout > 1
      --  if strcmp(order, 'stable') 
         --   indA = find(logIndA);           -- Find the indices of the unsorted logical.
        --else
            --indA = indSortA(groupsSortA);   -- Find the indices of the sorted logical.
            local indA = indSortA:index(1, groupsSortA:nonzero():view(-1) );   -- Find the indices of the sorted logical.
        --end
    --end
    
    -- Find indC. 
    --local indC, indC1
        if numelA == 0 then
            indC = torch.zeros(0)
        
        else
            indC1 = groupsSortA:long():cumsum();                         -- Lists position, starting at 1.
            indC = torch.zeros(indC1:size()):long()
            indC:indexCopy(1, indSortA, indC1)
        end
    
    
    return c, indA, indC
    
end