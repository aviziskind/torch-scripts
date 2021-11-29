require 'sys'
sys.memoryInfo = function()
    local mem_info_output = sys.execute('cat /proc/meminfo')
    local mem_info_strs = string.split(mem_info_output, '\n');
    
    local tbl_mem_info = {}
    
    for i,str in ipairs(mem_info_strs) do
        
        local fld_name = string.sub(str, 1, string.find(str, ':')-1)
        local fld_val_MB = tonumber( string.match(str, '[0-9]+') )/1024
        tbl_mem_info[fld_name] = fld_val_MB
        
    end
    return tbl_mem_info

end

sys.memoryAvailable = function()
    --return sys.execute('echo `free -m | grep Mem` | cut -d " " -f 4')  -- doesn't take into account buffers/cache
    
    local mem_info = sys.memoryInfo()
            
    local MemAvailable_MB = mem_info.MemAvailable or -1
    local MemFree_MB      = mem_info.MemFree or -1
    local Buffers_MB      = mem_info.Buffers or -1
    local Cached_MB      = mem_info.Cached or -1
    
    
    --local mem_avail_tot_MB = MemAvailable_MB + Buffers_MB + Cached_MB
    local mem_avail_tot_MB = MemAvailable_MB 
    local mem_avail_tot_sum_MB = MemFree_MB +  Buffers_MB + Cached_MB
          --printf("Free+Buff+Cached = %d\n", mem_avail_tot_sum_MB);
          
    if MemAvailable_MB == -1 then
        mem_avail_tot_MB = mem_avail_tot_sum_MB
    end
    return mem_avail_tot_MB
    
    --[[cat /proc/meminfo | grep MemAvailable | cut -d " " -f 4
    cat /
    MemAvailable:   260430628 kB
Buffers:            2292 kB
Cached:          4563796 kB

    return sys.execute( 'echo `free -m | grep "buffers/cache"` | cut -d " " -f 4' )
    --]]
end
    