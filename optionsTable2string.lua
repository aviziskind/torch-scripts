optionsTable2string = function(allOpts)
    local fnames = table.fieldnames(allOpts);
    
    local maxL = 0
    for i,nm in ipairs(fnames) do  maxL = math.max(maxL, #nm) end
    
    --local allLines = {}
    local str = ''
    for i,fname_i in ipairs(fnames) do
        
        local fname_i_disp = string.gsub(fname_i, 'tbl_', '');
        str = str .. string.format( '%' .. maxL .. 's: ', fname_i_disp)
        
        local isMultiple = string.sub(fname_i, 1, 4) == 'tbl_'
        local opts_i = allOpts[fname_i]

        if isMultiple and #(opts_i) == 1 then
            opts_i = opts_i[1]
            isMultiple = false
        end
        
        if isMultiple then
            
            local subOpts = allOpts[fname_i]
            str = str .. string.format(' (%d) %s \n', 1, tostring_inline(subOpts[1]) )
            for j = 2, #subOpts do
                str = str .. string.format('%s (%d) %s \n', string.rep(' ', maxL+2), j, tostring_inline(subOpts[j]) )
            end
            
        else
            str = str .. string.format(' %s \n', tostring_inline( opts_i ));
        
        end
    
    
    end

    return str
end