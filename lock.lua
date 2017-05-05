
lock = {}
lock.dir = paths.home .. '/Code/~locks/torch/' 
if not paths.dirp(lock.dir) then
    paths.createFolder(lock.dir)
end

debug_locks = false
debug_mode = false

hostname = os.getenv('hostname')  -- in my .bashrc script, this is set to be the hostname (hostname = $HOSTNAME)
    

lock.haveAnyLockWithThisBase = function(lock_name)
    lock_name = lock.removeInvalidChars(lock_name)
    
    withID = withID or true
    local lock_file_name = lock.getLockFileName(lock_name, withID)
    return lock.doesLockFileExist( lock_file_name, true )
    
end

lock.haveThisLock = function(lock_name)
    lock_name = lock.removeInvalidChars(lock_name)
    
    
    local lock_file_name = lock.getLockFileName(lock_name, true ) -- get OUR lock name
    return lock.doesLockFileExist( lock_file_name, false )
    
end



lock.isLocked = function(lock_name)
    lock_name = lock.removeInvalidChars(lock_name)
     
    local nLocksWithThisBase, lock_example = lock.nLocksWithThisName(lock_name)
    if nLocksWithThisBase == 0 then
        return false
    else        
        local _, otherProcessID = lock.getLockName(lock_example)
        return true, otherProcessID
    end
    --return lock.doesLockFileExist( lockFileName, true), 
    
end
    

lock.waitForLock = function(lock_name, waitIntervals_sec)
    lock_name = lock.removeInvalidChars(lock_name)
    local ourLockFileName = lock.getLockFileName(lock_name, true)
    
   
    local weHaveALock = lock.doesLockFileExist( ourLockFileName )
            
    if weHaveALock then
        return true
    end
    
    local otherLockFileName_base = lock.getLockFileName(lock_name, false)
    waitIntervals_sec = waitIntervals_sec or 5
    
    local firstTry = true
    local gotLockYet = false    
    local otherProcessID
    while not gotLockYet do
        gotLockYet, otherProcessID = lock.createLock(lock_name)    
        
        if not gotLockYet then
            if firstTry then
                io.write(string.format(' [Another process [%s] has lock [%s]. Waiting for it to be free :] \n  ', otherProcessID, lock_name))
                firstTry = false
            end
            
            sys.sleep(waitIntervals_sec)
            io.write('.');
        end
    end
        
    
end

-- lock_name = 'this_experiment'
-- lock_file_name = 'this_experiment.lock'
-- lock_file_name_withID = 'this_experiment.lock4'


lock.createLock = function(lock_name)
    assert(ID)
    
    -- try mark this experiment as being worked on:
    --  (1) check if any other processes have staked a claim on this experiment (if yes -> return false). if lock is from us, continue
    lock_name = lock.removeInvalidChars(lock_name)
    
    
    local lock_file_name = lock.getLockFileName(lock_name, false) -- don't add ThreadID
    
    local nLocksWithSameBase_AtStart, lock_example = lock.nLocksWithThisName(lock_name)
    if debug_locks then
        print(string.format('At start, there are %d locks with the same name)', nLocksWithSameBase_AtStart))
    end
        
    local secondsToWaitAfterCreatingLock = 0.5
    --local secondsToWaitAfterCreatingLock = 5

    
    --Lock_name = lock_name
    --lock_file_name = lock_file_name
    
    if nLocksWithSameBase_AtStart > 0 then
    
        local allLocksWithSameName = lock.getAllLocks(lock_name)
        if debug_locks then
            print('Here are all the locks with the same name:')
            print(allLocksWithSameName);
        end
        for _,lockFileName_i_withID in pairs(allLocksWithSameName) do
            local lockFileName_i, id_i = lock.getLockName( lockFileName_i_withID )
            --print('now is ', id_i)
            --print(string.format('Our ID = %s. Current ID = %s, equal = %s', id_i, ID, tostring(id_i==ID)))
            if (lockFileName_i == lock_file_name) and (id_i == ID) then -- we locked this before, and can now resume
                cprintf.red(' [Reclaiming lock : %s]', lockFileName_i_withID)
                return true
            end
        end
        
        local lockWithSameName = allLocksWithSameName[1] or lock_example
        -- there were locks, and they were not ours --> exit.
        local _, otherLockID = lock.getLockName(lockWithSameName)
        return false, otherLockID  -- "false"=could not place a lock because another process already has a lock.
    end
    
    
    --  (2) if none, stake a claim; wait for a second, and make sure no one else has staked a claim in the meantime 
    local lock_file_name_withID = lock.getLockFileName(lock_name, true) -- this time, add ThreadID 
    f = assert( io.open(lock.dir .. lock_file_name_withID, 'w') )
    f:close()
    cprintf.red(' [Locked : %s]\n', lock_file_name_withID)
    
    --lock_file_name_withID = lock_file_name_withID
    
    if not onLaptop then
        sys.sleep(secondsToWaitAfterCreatingLock)
    end
    
  --  local allLocks2 = lock.getAllLocks()
  --  local nLocksWithSameBase_AfterLocked = nInTableThatSatisfy(allLocks2, lock.getLockName, lock_file_name)
    
    
    
    --assert(nLocksWithSameBase>= 1) -- should have at least one lock (ie. the lock we just created)
 
    --[[ 
        repeat checking until either 
            (1) we're the only one retaining the lock --> return true, or we find another    
    --]]
    
   
    local nLocksWithSameBase = lock.nLocksWithThisName(lock_name)  
    if debug_locks then
        print(string.format('After opening, there are %d locks with the same name)', nLocksWithSameBase))
    end

    
    
    local nTriesMAX = 3
    local try_id = 1
    local lockFileNameExample, otherLockID
    while try_id <= nTriesMAX do
        nLocksWithSameBase, lockFileNameExample = lock.nLocksWithThisName(lock_name)  
       
        if nLocksWithSameBase == 1 and (lockFileNameExample == lock_file_name_withID) then 
            -- (3a) (if no other process placed the same lock -> return true)
            return true
        
        elseif (nLocksWithSameBase== 0) then
            -- (3b) wait a few more seconds for the file to register, perhaps?
            sys.sleep(secondsToWaitAfterCreatingLock*2) 
        
        elseif nLocksWithSameBase > 1 or (lockFileNameExample ~= lock_file_name_withID)  then
        -- (3c) if other processes have tried to place a lock, check whose threadId is higher (if current process has a higher threadId, return true; otherwise, delete lock and return false)
            cprintf.Red('Simultaneous locks! %d other session(s) tried to place this lock...\n', nLocksWithSameBase-1)
            local allLocksWithThisName2 = lock.getAllLocks(lock_name)
            for _,lock_i in pairs(allLocksWithThisName2) do
                
                local base_i, id_i = lock.getLockName(lock_i)
                assert(base_i == lock_file_name)
                if (id_i > ID) then -- another process has beaten us.
                    cprintf.Red('Thread %s has priority over us (%s). Conceding lock ... \n', tostring(id_i), tostring(ID)) 

                    lock.removeLock(lock_name)
                    return false, id_i
                elseif (id_i < ID) then -- we take priority
                    cprintf.Red('We (thread %s) take priority over thread %s. Waiting for thread %s to concede ...\n', tostring(ID), tostring(id_i), tostring(id_i) )
                    sys.sleep(secondsToWaitAfterCreatingLock) 
                end
            end        
        end
        
        -- no threads took priority over us, so we successfully retained the lock!
        try_id = try_id + 1
    end
    
    
    if (nLocksWithSameBase== 0) then
        cprintf.Yellow('Could not place a lock for some reason ..? Abandonding lock...')
            -- (3b) wait a few more seconds for the file to register, perhaps?
        return false
    end    
    if nLocksWithSameBase > 1 then -- other thread didn't concede -- give up
        
        lock.removeLock(lock_name)
        
        local _, otherLockName = lock.nLocksWithThisName(lock_name)
        _, otherLockID = lock.getLockName(otherLockName)
        
        cprintf.Red('Other thread(s) [ID = %s] did not concede. Abandonding lock...', otherLockID)
        return false
    end
    
    error('Shouldnt get to this point')
        
                    
end


lock.createMultipleLocks = function(lock_names)
    if type(lock_names) ~= 'table' then
        error('Table list of strings expected')
    end
    local nLocks = #lock_names
  
    -- first check if any of the locks are present:
    local nLocksWithSameBase, lockWithSameName
    for i,lock_name in ipairs(lock_names) do
        local lock_name_i = lock.removeInvalidChars(lock_name)
      
        local lock_file_name = lock.getLockFileName(lock_name, false) -- don't add ThreadID
    
        nLocksWithSameBase, lockWithSameName = lock.nLocksWithThisName(lock_name)
        if nLocksWithSameBase > 0 then
            local _, otherLockID = lock.getLockName(lockWithSameName)
            return false, otherLockID, lock_name        
        end
      
    end
  
    -- none of the locks detected. Try creating the locks, one by one:
    local gotLock, otherLockID
    for i,lock_name in ipairs(lock_names) do
       gotLock, otherLockID = lock.createLock(lock_name)
       if not gotLock then -- one of the locks was created while we were doing the first ones: undo previous locks
            for j = 1,i-1 do
                lock.removeLock(lock_names[j])
            end
            return false, otherLockID, lock_name
       end   
    end
    return true
  
    
  
end



lock.nLocksWithThisName = function(lock_name)
    
    local locksWithThisName = lock.getAllLocks(lock_name)
    return #(locksWithThisName), locksWithThisName[1]
        
end

lock.removeLock = function(lock_name)
    lock_name = lock.removeInvalidChars(lock_name)
    
    local lock_file_name_withID = lock.getLockFileName(lock_name, true)
    --print('removing: ', lock_name, lock_file_name_withID)
    
    os.execute('rm "' .. lock.dir .. lock_file_name_withID .. '"')    
    cprintf.red(' [Unlocked : %s]\n', lock_file_name_withID)
    
end

lock.getLockName = function(lock_file_name)
    local idx1, idx2, basename, id
    --if string.find(lock_file_name, '/') then
    --    lock_file_name = paths.basename(lock_file_name)
    --end
    if not lock_file_name then
        return '', ''
    end
    
    idx1, idx2 = string.find(lock_file_name, '.lock')
    --print('idxs : ', idx1, idx2, lock_file_name)
    basename = string.sub(lock_file_name, 1, idx2)  -- remove any trailing threadId
    id = ( string.sub(lock_file_name, idx2+1, #lock_file_name) )
    --print(id)
    return basename, id
end


lock.getLockFileName = function(lock_name, addThreadId_flag)
    
    local filename = lock_name .. '.lock'
    if addThreadId_flag and ID then
       filename = filename .. ID
    end
    return filename
    
end


lock.doesLockFileExist = function(lock_file_name_base, allowExt)
    --doesLockFileExist(lock_file_name, true) ==> does any lock file that starts with this base exist?
    --doesLockFileExist(lock_file_name, false) ==> does this particular lock file exist?
        
    local lock_file_name = lock.dir .. lock_file_name_base
    allowExt = allowExt or false
    local ext = ''
    if allowExt then
        ext = '*'
    end
        
    local ls_output = sys.ls(lock_file_name .. ext)

    if (ls_output == lock_file_name) or 
        (string.find( lock.removeInvalidChars(ls_output), lock.removeInvalidChars(lock_file_name)) == 1  and  allowExt) then
        return true
    elseif string.find(ls_output, 'No such file or directory') then
        return false
    else 
        error(string.format('file name was: \n   %s\n ls output was : \n   %s\n', lock_file_name, ls_output))  -- can this happen?
    end    
end

lock.getAllLocks = function(lock_name)
    if not lock_name then
        lock_name = '*'
    else
        lock_name = lock.removeInvalidChars(lock_name, 1) 
    end
    
    local ls_cmd = lock.dir .. lock_name .. '.lock*'
    
    if debug_locks then
        print(ls_cmd)
    end
    --Ls_cmd = ls_cmd
    local ls_output = sys.ls(ls_cmd)

    if string.find(ls_output, 'No such file or directory') then
        return {}
    end

    local all_lock_files = string.split(ls_output, '\n')
    for k,v in pairs(all_lock_files) do
        all_lock_files[k] = paths.basename(v)
    end
    return all_lock_files
end


lock.removeMyLocks = function()
    local thread_id_str
    if ID then
        thread_id_str = tostring(ID)
    else
        thread_id_str = ''
    end
    
    local ls_output = sys.ls(lock.dir .. '*.lock' .. thread_id_str)
    local someLocksFound = not string.find(ls_output, 'No such file or directory') 
    
    if someLocksFound then
        print('removing these locks : ', ls_output)
        os.execute('rm ' .. lock.dir .. '*.lock' .. thread_id_str)    
    else
        print('No locks from this process are present.');
    end
     
 
end



lock.removeAllLocks = function()
    local allLocks = lock.getAllLocks()
    --local ls_output = sys.ls(lock.dir .. '*.lock*')
    --local someLocksFound = not string.find(ls_output, 'No such file or directory') 

     
    if #allLocks == 0  then    
        print('No locks are present.');
    else
        print('Removing these locks:');
        print(allLocks)
        os.execute('rm ' .. lock.dir .. '*.lock*')    
        
    end
 
end


--[[
nInTableThatSatisfy = function(tbl, tbl_applyFunc, x)
    nFound = 0
    haveFunc = tbl_applyFunc ~= nil
--    tbl_ofFound = {}
        
    for k,v in pairs(tbl) do
        if haveFunc and tbl_applyFunc(v) == x then
            nFound = nFound + 1
  --          table.insert(tbl_ofFound, v)
            
        elseif not haveFunc and v == x then
            nFound = nFound + 1
--            table.insert(tbl_ofFound, v)

        end
    end

    return nFound
  
--    return #tbl_ofFound, tbl_ofFound
end
--]]

--[[
isInTable = function(x, tbl, applyFunc)
    haveFunc = tbl_applyFunc ~= nil
       for k,v in pairs(tbl) do
        if haveFunc and (tbl_applyFunc(v) == x) then
            return true
        
        elseif not haveFunc and v == x then
            return true
        end
    end

    return false
    
end
--]]
--[[
tablefun = function(func, tbl)
    tbl_new = {}
    for k,v in pairs(tbl) do
        tbl_new[k] = func(v)
    end
end
--]]

lock.waitUntilNoLocks = function(lock_name)
    lock_name = lock_name or '*'
    local interval_sec = 30
    
    --[[
    local debug = false
    
    if debug then
        interval_sec = 1
    end
    --]]
    
    local firstTime = true
    while true do
        local nLocks = #(lock.getAllLocks(lock_name))
        
        if firstTime then
            if nLocks == 0 then
                io.write('No locks!\n')
                return
            else
                io.write(string.format('There are currently n=%d lock(s) of type "%s". Waiting until they are all removed...\n', nLocks, lock_name))
            end
        elseif nLocks == 0 then
            io.write('No more Locks!\n')
            return
        else
            io.write('.')
        end
        
        sys.sleep(interval_sec)
        firstTime = false
        
        
    end
     
end



lock.testLock = function()
    
    if not ID then
        error('Need to test with multiple threads')
    end
    local nSecEachExperiment = 5

    local waitUntilSync = true


    local nExperiments = 10
    for i = 1, nExperiments do
       
        local sync = false
        local sync_time = 10
        local last_t = 0
        while not sync do
            t = math.modf( math.floor(sys.clock()), sync_time)
            if (t == 0) then
                sync = true
            else
                if (t ~= last_t) then
                    last_t = t
                    io.write(string.format('%d,', sync_time - t))
                end
                sys.sleep(.1)
            end
        end
        print('starting', i)
       
       
        local lock_name = 'test_experiment' .. i
        local file_name = lock.dir .. 'test/file' .. i

        if not paths.filep(file_name) then

            local isLocked, otherLockID = lock.createLock(lock_name)

            io.write(string.format('\n\n%s\n', lock_name))

            if isLocked then
                io.write(string.format('  -- Great! We (ID = %s) got lock on %s\n', ID, lock_name))
                
                f = assert( io.open(file_name, 'w') )
                f:close()
                
                io.write('"Creating" the file : ');
                for i = 1,nSecEachExperiment do
                    io.write('.');
                    sys.sleep(1);
                end

                io.write(string.format('  -- We (ID = %s) are done, removing lock on %s\n', ID, lock_name))
                lock.removeLock(lock_name)
            else
                io.write(string.format('  -- Could not lock %s. Another process (ID = %s) has already locket it\n', lock_name, otherLockID))
            end

        end
           
   end
    
    
end

lock.removeInvalidChars = function(lock_name, keepStarsFlag)
    lock_name = lock_name or ''
    lock_name = string.gsub(lock_name, '[[]', '_')
    lock_name = string.gsub(lock_name, '[]]', '_')
    lock_name = string.gsub(lock_name, '[-]', '_')
    if not keepStarsFlag then
        lock_name = string.gsub(lock_name, '[*]', '_')
    end
    
    return lock_name
end

