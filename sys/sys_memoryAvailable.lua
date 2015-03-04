require 'sys'
sys.memoryAvailable = function()
    --return sys.execute('echo `free -m | grep Mem` | cut -d " " -f 4')  -- doesn't take into account buffers/cache
    return sys.execute( 'echo `free -m | grep "buffers/cache"` | cut -d " " -f 4' )
end
    