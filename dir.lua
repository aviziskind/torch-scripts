dir = function(folder, wildCardsAfter_flag)
    
    --[[
    fileArgs = fileArgs or ''
    if string.sub(folder, #folder, #folder) ~= '/' then
        folder = folder .. '/'
    end
    --]]
    
    local haveWildCards = string.find(folder, '*') or string.find(folder, '?') 
    
    local ls_output, folder_arg, pattern
    if wildCardsAfter_flag then
        folder_arg = paths.dirname(folder)
        pattern = paths.basename(folder)
    else
        folder_arg = folder 
    end
    cprintf.cyan('Initial run ... ');
    ls_output = sys.ls(folder_arg)
    cprintf.cyan('done!\n');
    
    if string.find(ls_output, 'No such file or directory') then
        return {}
    elseif string.find(ls_output, 'Argument list too long') then 
        if not wildCardsAfter_flag then
            cprintf.red('file list too long, running again with wildcards postponed.\n');
            return dir(folder, 1)
        else
            error('Could not parse dir even when wildCardsAfter_flag was set');
        end
    else
        --cprintf.cyan('Running again, piping to basename\n');
        --ls_output = sys.ls(folder_arg .. '| xargs -n1 basename')
        --cprintf.cyan('Done...!\n');
        --Ls_output2 = ls_output
        cprintf.cyan('Spliting ... ');
        local all_filenames = string.split(ls_output, '\n')
        cprintf.cyan('Done...!\n');
        
        cprintf.cyan('Basename...');
        for i = 1,#all_filenames do
            all_filenames[i] = paths.basename(all_filenames[i]);
        end
        cprintf.cyan('Done...!\n');
        
        if wildCardsAfter_flag then
            local all_filenames_keep = {}
            local pattern_lua = pattern
            --[[
            local escapeChars = '%.[]'
            for i = 1,#escapeChars do
                local char = string.sub(escapeChars, i,i)
                pattern_lua = string.gsub( pattern_lua, char, '%' .. char) -- in lua . = any character, .* = any+
            end
                --]]
            pattern_lua = string.gsub( string.gsub(pattern_lua, '?', '.'), '*', '.*') -- in lua . = any character, .* = any+
            
            printf('pattern = %s\n', pattern_lua)
            All_filenames = all_filenames
            for i,fn in ipairs(all_filenames) do
                if string.match(fn, pattern_lua) then
                    table.insert(all_filenames_keep, fn)
                end
            end
            all_filenames = all_filenames_keep
        end
        return all_filenames
        
    end
    

end