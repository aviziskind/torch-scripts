estimateSNRthreshold = function(logSNRs, pcorrect)
    
    if not logSNRs then
        logSNRs = {0, 1, 2, 3, 4}
    end
    
    if not pcorrect then
        pcorrect = {4.3, 7.8, 58.9, 97.2, 98.2}    
        --pcorrect =  {6.1, 26.6, 96.6, 100, 100}
    end
    
    if type(pcorrect) == 'table' then
        pcorrect = torch.Tensor(pcorrect)
    end
    if type(logSNRs) == 'table' then
        logSNRs = torch.Tensor(logSNRs)
    end
    logSNRs = logSNRs:reshape(logSNRs:numel())
    local SNRs = logSNRs:clone():apply( function(x) return 10^x; end)
    
    assert(torch.typename(logSNRs) == torch.typename(pcorrect) )
    
    local gamma = 1/26;
    local th_pctCorrect = 64;
    if pcorrect:max() < th_pctCorrect then
        return 0;
    end
    
    
    --[snr_th, bestFitFunc, snr_th_ci, b_best_fit] = getSNRthreshold(logSNRs, pcorrect);
    
    
    -- do a grid search over multiple possible thresholds and slopes
    local nSNRs_try = 200
    local nSlopes_try = 15;
    
    local all_logThr_try = torch.linspace(0, 4, nSNRs_try)
    local all_thr_try = all_logThr_try:clone():apply( function(x) return 10^x; end)
    local all_slopes_try = torch.linspace(1, 3, nSlopes_try)
    
    local bestErr, curErr
    local bestSlope = 0
    local bestLogTh = 0
    local beta_cur = torch.Tensor({pcorrect:max() / 100, 0, 0})
    local beta_best = beta_cur:clone()
    --print(beta_cur)
    
    local sumSqrDiffs = function(x, y)
        local diffs = x - y;
        return diffs * diffs; -- dot product with itself = sum of squares
    end
    
    for sl_i = 1,nSlopes_try do
        for th_i = 1,nSNRs_try do
            
            beta_cur[2] = all_thr_try[th_i];
            beta_cur[3] = all_slopes_try[sl_i]
            
            local p_corr_i = weibull(beta_cur, SNRs, gamma)*100
    
            curErr = sumSqrDiffs (p_corr_i, pcorrect)
            --io.write(string.format('%.1f, ', curErr))
            if (not bestErr) or curErr < bestErr then
                bestErr = curErr
                beta_best[2] = beta_cur[2]
                beta_best[3] = beta_cur[3]
                --print(string.format('best : max = %.1f, th = %.1f, slope = %.2f', beta_best[1], beta_best[2], beta_best[3]))
                --print(p_corr_i)
                
            end 
            
        end
    end

    -- now that we have the best threshold and slope parameters, estimate the 64% correct threshold (local linear interpolation for slight increase in accuracy)
    local p_corr_est = weibull(beta_best, all_thr_try, gamma)*100;
    local x1, x2, y1, y2, frac, snr_th_est
    for i = 1,nSNRs_try-1 do
        
        y1, y2 = p_corr_est[i], p_corr_est[i+1];
        
        if (y1 < th_pctCorrect) and (y2 >= th_pctCorrect) then
            x1, x2 = all_logThr_try[i], all_logThr_try[i+1]
            frac = (y2-th_pctCorrect)/(y2-y1) 
            snr_th_est = x1 + (x2-x1)*frac
            break;
        end
        
    end
    
    return snr_th_est, beta_best
    
end



   
