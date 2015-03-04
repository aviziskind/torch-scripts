function torch.find(x, val, k)
    
    if not torch.typename(x) then
        error('X is not a valid torch type')
    end
    
    local count = 0
    
    local s = x:storage();
    local n = x:numel()
        
    for i = 1,n do
        if (val and (s[i] == val)) or (not val and s[i] ~= 0)  then
            count = count  + 1
            if k and count >= k then
                break;
            end
        end 
        
    end
    
    local indices = torch.Tensor(count);
    local curIdx = 1
    for i = 1,n do
        if (val and (s[i] == val)) or  (not val and s[i] ~= 0) then
            if k and curIdx > k then
                break
            end
            indices[curIdx] = i
            curIdx = curIdx + 1
        end
        
    end
        
		
	return indices
end
