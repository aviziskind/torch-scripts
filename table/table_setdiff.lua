table.setdiff = function(tbl1, tbl2, returnNilIfEmpty)
    
    local tbl3 = {}
    for i,v1 in ipairs(tbl1) do
        local foundInTbl2 = false
        for i,v2 in ipairs(tbl2) do
            if v1 == v2 then
                foundInTbl2 = true;
                break;
            end
        end
        if not foundInTbl2 then
            table.insert(tbl3, v1)
        end
    end    

    if #tbl3 == 0 and returnNilIfEmpty then
        tbl3 = nil
    end

    return tbl3
    
    
end
