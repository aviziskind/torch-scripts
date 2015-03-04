getCommandPIDs = function(cmd)
    if not cmd then
        cmd = 'torch-qlua'
    end
    
        --return sys.execute('ps -C 'torch-qlua');
    local allPIDs = {}
    s = sys.execute('ps -C ' .. cmd)    
    s2 = s
    
    -- remove leading spaces before each line
    while true do
        s2 = s:gsub('\n ', '\n') 
        if s == s2 then
            break
        end
        s = s2
    end
    
    
    while true do
        idx_newline = string.find(s, '\n')
        if not idx_newline then
            break;
        end
        s2 = string.sub(s, idx_newline+1, #s) 
    
        idx_number = string.find(s2, '%d')
        idx_space = string.find(s2, ' ')
        if not idx_space then
            break;
        end
        
        local pid = tonumber( string.sub(s2, 1, idx_space) )
        table.insert(allPIDs, pid)
        
        s = s2
        
    end
    
    return allPIDs
    
end

--[[
        idx_newline = string.find(s, '\n')
        s2 = string.sub(s, idx_newline+1, #s) 
    
        idx_space = string.find(s2, ' ')
        local pid = tonumber( string.sub(s2, 1, idx_space) )
        table.insert(allPIDs, pid)
        
        s = s2
--]]