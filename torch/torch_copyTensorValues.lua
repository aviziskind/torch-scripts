
torch.copyTensorValues = function(t1, t2)
    T1 = t1
    T2 = t2
    local iter1 = torch.tensorIterator(t1)
    local iter2 = torch.tensorIterator(t2)
    
    local s1 = t1:storage()
    local s2 = t2:storage()
    
    while true do
        local i1, v1 = iter1()
        local i2, v2 = iter2()
        
        if not v1 or not v2 then
            break
        end
        --printf('[%d(%.1f)->%d(%.1f)]\n', i1, v1, i2, v2)
        s2[i2] = v1
        
    end
    
end


