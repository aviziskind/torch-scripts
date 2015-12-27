require 'sys'

--[[ usage: (like matlab):
-- usage 1: (simple usage for a single timer)
tic
... 
t = toc


-- usage 2: (multiple timers running independently)
t1 = tic
...
t2 = tic
...
tElapsed1 = toc(t1)
...
tElapsed2 = toc(t2)
--]]

tic = function()    
    
    --__default_timer = torch.Timer()
    __tic_toc_startTime__ = sys.clock()
    
    return __tic_toc_startTime__
end

toc = function(tStart)
    --time_elapsed_t = __default_timer:time()
    if tStart and type(tStart) ~= 'number' then
        error('Input must be a number or nil')
    end
    
    if not tStart then
        tStart = __tic_toc_startTime__
    end
    
    local timeElapsed_sec = sys.clock() - tStart
    
    return timeElapsed_sec
end