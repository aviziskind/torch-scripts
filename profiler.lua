--[[
profiler = {}

profiler.status = 'off'

profiler.init = function()
    profiler.timer = torch.Timer()
    profiler.allBlocks = {}  -- table of all blocks (hashed for quick access)
    profiler.blockList = {}  -- numerical list of blocks in order that are encountered.
end


profiler.mark = function(curBlockName, curPointName)
    if profiler.status ~= 'on' then
        return
    end
    
    if not (profiler.allBlocks[curBlockName]) then -- first time entering this block
       
        profiler.allBlocks[curBlockName] = {}
        table.insert(profiler.blockList, curBlockName)
        
        curBlock = profiler.allBlocks[curBlockName]
        
        curBlock.firstPoint = curPointName
        curBlock.allPoints = {}
        curBlock.pointIdx = 1
              
    end
    local isFirstPointInBLock = curBlock.firstPoint == curPointName
    
    if isFirstPointInBLock then
        curTime = profiler.timer:time()
        
        curBlock.time = curTime
    else
        
        
    
    
    end
    
    
    local 
        
    
    
    
    
end


profiler.view = function()
    
    
    
end



function test1()
    
    -- do something
    profiler.mark('test1', 'start')
    
    -- do more
    profiler.mark('test1', 'mid')
    
    -- do more
    profiler.mark('test1', 'end')
    
end
    
profiler.allBlocks.test1 = {'start', 'mid', 'end'}
    
    
    
    --]]