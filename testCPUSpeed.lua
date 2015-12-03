testCPUSpeed = function(nSeconds, doRand)
    
    nSeconds = nSeconds or 2
    if doRand == nil then
        doRand = true
    end
    local elapsed = 0
    
    local t0 = os.time()
    -- wait until start of new second
    local i_wait = 0;
    while (os.time() == t0) do
        i_wait = i_wait + 1;
    end
    
    local t1 = os.time()
    local a = 0;

    local nRand = 100000

    print('Start')
    local count = 0;
    while elapsed < nSeconds do
        if doRand then
            torch.randn(nRand)
        end
        local a,b = math.modf(count/1)
        --io.write('.')
        --if (b == 0) then
        local t2 = os.time()
        elapsed = t2 - t1
        --end
        count = count + 1
   
    end
    print('Done')
    local speed = count / nSeconds
    if doRand then
        io.write(string.format('Speed : %.3f million rands per second\n', (count * nRand / (nSeconds * 1e6)) ))
    else
        io.write(string.format('Speed : %.3f million loops per second\n', (count / (nSeconds * 1e6)) ))
    end
    
   
    
end

--[[

XPS: 14.5
banquo: 9.5
cassio: 9.7





rose1: 11.25









texier: 5.1 million loops / sec
--]]