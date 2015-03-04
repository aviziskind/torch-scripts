loadTorchSessions = function(nSessions, cmd)
    nSessions = nSessions or 2
    --cmd = cmd or '/home/avi/Code/torch/letters/startSession.lua'
    cmd = cmd or 'startSession.lua'
    
    local assignSessionsToCPUs = true
    local makeSessionsLowPriority = true
    
    lock.removeAllLocks()
    
    --torch_cmd = '/usr/local/torch7_old/bin/torch'
    
    -- make sure working directory is /Code/torch/letters
    --paths.cwd()
    
    
    -- launch the torch sessions in a new window (under different tabs)
    local os_cmd = 'gnome-terminal  --geometry 190x40+100+50 ';
    local curPIDs = getCommandPIDs('torch-qlua')
    --curPIDs_sym = table.toSymtable(curPIDs)

    for session_i = 1,nSessions do
--        os_cmd = os_cmd .. string.format('--tab -e "%s %s -THREAD_ID %d" --title=%d  ', torch_cmd, cmd, session_i, session_i)
        local thread_arg = string.format('-THREAD_ID %d -N_THREADS_TOT %d', session_i, nSessions)
        if #cmd == 0 then
            thread_arg = ''
        end
        os_cmd = os_cmd .. string.format('--tab -e \'bash -c "torch -i %s %s" \' --title=%d  ', cmd, thread_arg, session_i)

--gnome-terminal --tab -e 'bash -c "torch main.lua -THREAD_ID 2;read"'

    end
    print(os_cmd)
    os.execute(os_cmd)
    
    -- find the new torch processes, and assign each one to its own CPU
    allPIDs = {}
    
    newPIDs = {}
    local sec = 0;
    io.write(string.format('Loading %d more torch sessions ', nSessions))
    while true do
        sec = sec + 1
        sys.sleep(1)
        allPIDs = getCommandPIDs('torch-qlua', 1)
       
        io.write('.')
        nNew = #allPIDs - #curPIDs
        if (nNew == nSessions) then
            io.write(' done\n');
            break
        end
        
        if sec > 5 then
            io.write('\nError: torch sessions were not loaded (or they exited immediately). Exiting...');
            return
        end
        
    end

--[[
    print('initial')
    print(curPIDs)
    print('now')
    print(allPIDs)
--]]
    
    newPIDs = table.toSymtable(allPIDs)
    for i,pid in ipairs(curPIDs) do
        assert(newPIDs[pid] ~= nil)
        newPIDs[pid] = nil
    end
    
    if assignSessionsToCPUs or makeSessionsLowPriority then
        cpu_id = 0
        for pid,_ in pairs(newPIDs) do
            io.write(string.format('Pid %d : ', pid))
                    
            if assignSessionsToCPUs then
                setProcessAffinity(pid, cpu_id)
                io.write(string.format('Assigned to CPU %d. ', cpu_id))
                cpu_id = cpu_id + 1
            end
            
            if makeSessionsLowPriority then
                setProcessPriority(pid, 'Low')
                io.write(string.format('Set Priority to Low'))
            end
            io.write('\n')
        end
    end        
    
end




setProcessAffinity = function(pid, cpu_id)    
    os.execute(string.format('taskset -pac %d %d >/dev/null', cpu_id, pid))
end

setProcessPriority = function(pid, priority)
    local priority_values_table = {Very_Low = 10, Low = 5, Normal = 0, High = -5, Very_High = -10}
    
   
    if type(priority) == 'string' then
        if priority_values_table[priority] == nil then
            error('Invalid priority value')
        end
        priority = priority_values_table[priority]
    end
        
    os.execute(string.format('renice %d -p %d >/dev/null', priority, pid))
end


