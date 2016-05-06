
torch.uniqueCount = function(A)
    local combineNanValues = true;
        
    -- Provides counts of each unique value
    --if iscell(A) && ~isempty(A) && isnumeric(A{1}) && (length(A{1}) > 1)
    --    A = cellfun(@(x) num2str(x(:)'), A, 'Un', false);
    --end    
    local uniqueVals, ind_in_A, val_idx = torch.unique(A)
    
    local count = torch.zeros(ind_in_A:size())
    for i = 1, val_idx:numel() do
        count[val_idx[i]] = count[val_idx[i]] + 1
    end

--[[
    if combineNanValues then
        nanIdxs = torch.isnan(uniqueVals):nonzero()
        if nanIdxs:numel() > 0 then
            uniqueVals(nanIdxs(2:end)) = [];
            count(nanIdxs(1)) = length(nanIdxs);
            count(nanIdxs(2:end)) = [];                     
        end        
    end
    --]]
--     count = arrayfun(@(i) nnz(n == i), 1:length(b));    
    return uniqueVals,count
end

--]]