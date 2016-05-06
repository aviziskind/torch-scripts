

function weightedResample(probs, nsamples)
    N = probs:numel()
    if not torch.all ( probs:ge(0) ) then
        error('All probabilities must be greater than 0')
    end
    if probs:sum() ~= 1 then
        if probs:sum() == 0 then
            error('All probabilities are 0')
        end
        probs:div(probs:sum())
    end
    probs_cum = torch.concat(0, probs:cumsum())
    
    rand_numbers = torch.rand(nsamples)
    tic()
    idxs = torch.binarySearch(probs_cum, rand_numbers, -1, -1)
    local t1 = toc()
    
    local doLinearCheck = false;
    if doLinearCheck then
        tic()
        idxs_chk = torch.Tensor(nsamples)
        for i = 1,nsamples do        
            idxs_chk[i] = 1
            while idxs_chk[i] < N and probs_cum[idxs_chk[i]+1] < rand_numbers[i] do
                idxs_chk[i] = idxs_chk[i] + 1;
            end  
        end
        local t2 = toc()
    
        ass1ert(isequal(idxs, idxs_chk))
        printf('%.4f times faster\n', t2/t1)
    end
    
    return idxs
    
end