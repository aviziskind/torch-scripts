 table.reorderAs = function(tbl, orderedTable)
    --local orderedTable = {'Roman', 'Bold', 'Italic', 'BoldItalic'}
    local tbl_new = {}
        
    for i,orderedEntry in ipairs(orderedTable) do
        
        for j,newEntry in ipairs(tbl) do
            if orderedEntry == newEntry then
                table.insert(tbl_new, orderedEntry)
            end
        end
        
    end
    
    if #tbl_new < #tbl then
        error(string.format('One (or more) of these entries was not in the ordered table:\n %s\n', table.concat(tbl, ', ')))
    end
        
end