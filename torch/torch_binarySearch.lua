torch.binarySearch = function(data, item, dirIfFound, dirIfNotFound) 
    
    local DIR_IF_FOUND_DEFAULT     = -1
    local DIR_IF_NOT_FOUND_DEFAULT = 2
            
    dirIfFound = dirIfFound or DIR_IF_FOUND_DEFAULT
    dirIfNotFound = dirIfNotFound or DIR_IF_NOT_FOUND_DEFAULT
    
    if type(dirIfFound) == 'string' then
        if dirIfFound == 'first' then
            dirIfFound = -1
        elseif dirIfFound == 'last' then
            dirIfFound = 1
        elseif dirIfFount == 'any' then
            dirIfFound = 0
        else 
            error('Input 3 (dirIfFound), if input as a string, must be either "first", "last", or "any"' )
        end
    elseif type(dirIfFound) == 'number' then
        if not table.anyEqualTo(dirIfFound, {-1, 0, 0.5, 1, 2}) then
            error('Input 3 (dirIfFound) must be either -1, 0, or 1')
        end
    end
    
    if type(dirIfNotFound) == 'string' then
        if dirIfNotFound == 'exact' then
            dirIfFound = 0
        elseif dirIfNotFound == 'down' then
            dirIfFound = -1
        elseif dirIfNotFound == 'up' then
            dirIfFound = 1
        elseif dirIfNotFound == 'closest' then
            dirIfFound = 2
        elseif dirIfNotFound == 'frac' then
            dirIfFound = 0.5
        else 
            error('Input 4 (dirIfNotFound), if input as a string, must be either "exact", "down", "up", "closest", or "frac"')
        end
    elseif type(dirIfNotFound) == 'number' then
        if not table.anyEqualTo(dirIfNotFound, {-1, 0, 0.5, 1, 2}) then
            error('Input 4 (dirIfNotFound) must be either -1, 0, 1, 2, or 0.5')
        end
    end
    
    
    local pos
    if type(item) == 'number' then
        pos = torch.binarySearch_helper(data, item, dirIfFound, dirIfNotFound)
        
    elseif torch.isTensor(item) then
        pos = torch.Tensor(item:numel())
        for i = 1,item:numel() do
            pos[i] = torch.binarySearch_helper(data, item[i], dirIfFound, dirIfNotFound)
        end
        pos = pos:reshape(item:size())
    else 
        error('Item must be a number or a tensor')
    end

    return pos


end

torch.binarySearch_helper = function(data, item, dirIfFound, dirIfNotFound) 
    
    
    local iPos = 0
    local dPos = 0
    local foundItem = false
    local lower = 1
    local N = data:numel()
    local upper = N
    local mid
            
    
    while ((upper > lower+1) and (iPos == 0)) do
        mid = math.floor((upper+lower)/2)
        if (data[mid] == item) then
            iPos = mid
            foundItem = true
        
        else 
            if (data[mid] > item) then
                upper = mid
            else
                lower = mid
            end
        end
    end
    
    if (not foundItem) then    --  didn't find during search: test upper & lower bounds 
        if (data[upper] == item) then
            iPos = upper
            foundItem = true
        elseif (data[lower] == item) then
            iPos = lower
            foundItem = true
        end
    end
        
    if foundItem then
        if (dirIfFound == -1) then
            while ((iPos > 1) and (data[iPos-1] == data[iPos])) do
                iPos = iPos - 1
            end
        
        elseif (dirIfFound == 1) then
            while ((iPos < N) and (data[iPos+1] == data[iPos])) do
                iPos = iPos + 1
            end
        end


    elseif (not foundItem) then
        if (dirIfNotFound == -1) then
            if (item > data[upper]) then  -- this could be true if upper is at the end of the array
                iPos = upper
            else 
                iPos = lower     
            end
        
        elseif (dirIfNotFound == 0) then
            iPos = 0  
                
        elseif (dirIfNotFound == 0.5) then
            dPos = lower + (item-data[lower])/(data[upper]-data[lower])          

        elseif (dirIfNotFound == 1) then
            if (item < data[lower]) then  -- this could be true if lower is at the start of the array
                iPos = lower
            else 
                iPos = upper
            end
        
        elseif (dirIfNotFound == 2) then
            if (math.abs(data[upper]-item) < math.abs(data[lower]-item)) then
                iPos = upper
            else
                iPos = lower
            end
        end
        
    end

    if (dPos == 0) then  -- most of the time, except when dirIfNotFound = 0.5
        dPos = iPos
    end
    
    return dPos
end







torch.testBinarySearch = function()
--     idx = binarySearch(data, items, dirIfFound, dirIfNotFound)    

    -- This function tests the binarySearch algorithm to verify that it
    -- gives the correct output using various different parameters. In the 
    -- cases where the indexes are not known beforehand, the 
    -- output is checked by comparing it with Matlab's built-in linear
    -- search ("find") method.

    printf('Running checks ... ')
    local N = 100;

    
    randi = function(i,n) 
        return torch.ceil(torch.rand(n)*i)
    end
    -- 0. Basic test - exactly 1 occurence of each item in the data array.
    data = torch.sort(torch.randn(N))
    idx_orig = randi(N, 10) --  torch.ceil(torch.rand(N)*N)
    items = data:index(1, idx_orig:long())
    idx_bsearch = torch.binarySearch(data, items)
    
    assert(isequal(idx_orig, idx_bsearch)) -- make sure the indices match the original indices
            
    
    -- 1. Test behavior if multiplies copies are found (using dirIfFound parameter)
    local n = 10;
    data = torch.sort(randi(n, N)) -- multiple copies of the numbers 1..10
    items = torch.range(1,n)

    firstPos_linSearch = torch.Tensor(n)
    lastPos_linSearch = torch.Tensor(n)
    for i = 1,n do
        firstPos_linSearch[i] = torch.find(data, i, 1, 'first')
        lastPos_linSearch[i]  = torch.find(data, i, 1, 'last')
    end
    
    firstPos_bSearch   = torch.binarySearch(data, items, 'first')
    assert(isequal(firstPos_linSearch, firstPos_bSearch))

    --lastPos_bSearch    = torch.binarySearch(data, items, 'last')
    --assert(isequal(lastPos_linSearch, lastPos_bSearch));

    -- 2. test behavior if items are not found (using dirIfNotFound)
--[[
    -- 2a. test  dirIfNotFound = 0  (== return 0 if item not found)
    s = torch.range(-3, 13, 0.5) -- [-3:.5:13];  -- [ranges from 1 to 9.999]  
    pos = binarySearch(data, s, [], 'exact');
    assert( all( s(pos == 0) == setdiff(s, data) ) );            
    
    -- 2b. test  dirIfNotFound = down/up
    data = [1:10];
    items = 1 + rand(N,1) * 9;  -- [ranges from 1 to 9.999]  
    pos = binarySearch(data, items, [], 'down');
    actualPos = floor(items);
    assert(isequal(pos, actualPos));

    actualPos = ceil(items);
    pos = binarySearch(data, items, [], 'up');
    assert(isequal(pos, actualPos));
    
    -- 2c. test  dirIfNotFound = 0.5
    pos = binarySearch(data, items, [], 'frac');
    assert(isequal(pos, items));
    
    
    -- 3. test the sort checking option.    
    data_notSorted = 10:-1:1;
    items = [5,6];
    -- 4a. verify that we don't get an error if the first argument is not sorted
    try 
        binarySearch(data_notSorted, items);    
    catch MErr
        error('Should not have generated an error');        
    end        
    
    -- 4b. verify that we *do* get an error if we tell the algorithm 
    -- to check the sorting.
    checkFlag = 1;
    try 
        binarySearch(data_notSorted, items, [], [], checkFlag);
        error('Should have generated an error');
    catch MErr
        assert(strcmp(MErr.message, 'Input 1 (data) must be sorted.'));
    end
    fprintf(' All checks passed!\n');
--]]
    
    printf('Running speed test...\n');
    
    -- Speed test:
    -- compare speed with Matlab's "find" function.
    local Ns = {1e2, 1e3, 1e4, 1e5, 1e6}
--     t_ratios = zeros(1,size(Ns));
    for i = 1,#Ns do
        data = torch.sort(torch.randn(Ns[i]))
        idx_orig = randi(Ns[i], 10);
        items = data:index(1, idx_orig:long())
        -- regular matlab "find"
        tic();
        idx_find = torch.Tensor(n)
        for i = 1,n do
            idx_find[i] = torch.find(data, items[i], 1, 'first')
        end        
        --idx_find = arrayfun(@(x) find(data == x, 1), items);
        t1 = toc();
        -- binary search; (use "dontCheckFlag" to skip checking b/c we know
        -- the data is sorted.
        tic();
        idx_bsearch = torch.binarySearch(data, items);
        t2 = toc();
        assert(isequal(idx_orig, idx_find)); -- make sure the indices match the original indices
        assert(isequal(idx_orig, idx_bsearch)); -- make sure the indices match the original indices
        t_ratio = t1/t2;
        printf('For array size N =-- %d, binarySearch is ~%.1f times faster than find\n', Ns[i], t_ratio);
    end
    
    --[[
    -- check single / double handling
    data_d = sort(randn(1, 1000));
    items_d = rand(1, 100);
    data_f = single(data_d);
    items_f = single(items_d);
    
    idx_dd = binarySearch(data_d, items_d);
    idx_ff = binarySearch(data_f, items_f);
    idx_df = binarySearch(data_d, items_f);
    idx_fd = binarySearch(data_f, items_d);

    assert(isequal(idx_dd, idx_ff));
    assert(isequal(idx_dd, idx_fd));
    assert(isequal(idx_dd, idx_df));
    3;
 --]]
    
    --]]
end