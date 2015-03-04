setID = function()
    
    local alwaysUseHostAndPID = true
    local preferRemoteID = true
    host = os.getenv('host')
    
    local pid_use
    local remote_id = os.getenv('remote_id')
    local bash_pid = os.getenv('bashpid')
    if host == 'XPS' and THREAD_ID then
        pid_use = THREAD_ID
    elseif preferRemoteID and remote_id then
        pid_use = remote_id
    else
        pid_use = bash_pid
    end
        
    if alwaysUseHostAndPID then
        ID = '_' .. host .. '_' .. pid_use
        
    elseif THREAD_ID then
        ID = '_' .. THREAD_ID
    elseif string.find(hostname, 'nyu.edu') then
        ID = '_' .. string.sub(hostname, 1, string.find(hostname, '%.')-1) .. '_' .. pid_use
    else
        ID = '_' .. pid_use -- in my .bashrc script, this is set to be the process_id (pid = $$ [not $PPID, that's the parent id])
    end

end

setID()