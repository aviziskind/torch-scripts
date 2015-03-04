--require('mobdebug').start()


-- syntax:
-- before running a loop, initialize the progress bar with
-- progressBar.init(([<startAt>, ntrials], <nbars>, style);  -- (the 'startAt' and <nbars> parameters are optional)
-- style can be '' (for inline progressbar) , or '=', to run on a separate line with a bar above

-- then, at some point during the loop (for i = startAt:ntrials, for each iteration,)
-- run:
--    progressBar.step(i);
-- or, alternatively, just:
--    progressBar.step

-- that's it!

-- to return to the next line, after the loop has finished, type
--    progressBar.done;   

require 'math'
progressBar = {}

progressBar.init = function(stepsToDoDetails, nTotalBars, displayStyle_flag, autoRestart_flag)
    
    
    local pb = progressBar
    pb.allowBreakWithFile = false; -- at beginning and end of bar
   
    pb.X = '*';
                
    pb.laststr = '';
    pb.timer = torch.Timer()
    pb.saveProgressInFile = false;
    pb.showTimeRemaining = true

            
            -- A. PARSE INPUTS
            -- (1) Determine output style:
--            if (arg.n >= 3) 
--            switch varargin{1}
--                case 'init',  displayStyle = SAME_LINE;
 --               case 'init-', displayStyle = SEPARATE_LINE;
 --               case 'init=', displayStyle = GUI;
  --          end
    pb.displayStyle = 'same-line'
                        
    -- (2) Determine where to start & where to end:
    
    pb.nStepsDoneAtStart = 0
    
    if type(stepsToDoDetails) == 'number' then
        pb.nStepsTotal = stepsToDoDetails
    elseif (#stepsToDoDetails) == 1 then
        pb.nStepsTotal = stepsToDoDetails[1]
    elseif (#stepsToDoDetails) == 2 then
        pb.nStepsDoneAtStart = stepsToDoDetails[1]
        pb.nStepsTotal = stepsToDoDetails[2];
    end
    
    -- (3) Determine how many bars
    
    if not nTotalBars then
        if pb.displayStyle == 'same line' then
            nTotalBars = torch.min(10, pb.nStepsTotal);
        else --if displayStyle == 'new line' then
            nTotalBars = torch.min(40, pb.nStepsTotal);
        end
    end
    pb.nTotalBars = nTotalBars
                    
    pb.stepsPerBar = pb.nStepsTotal / pb.nTotalBars
    pb.nStepsDone = pb.nStepsDoneAtStart
        
    -- B. INITIALIZE PROGRESS BAR
    -- 1. Basics
    pb.autoRestart = (autoRestart_flag ~= nil) and (autoRestart_flag ~= false)
    if type(autoRestart_flag) == 'boolean' then
        pb.nStarts = 1
    elseif type(autoRestart_flag) == 'number' then
        pb.nStarts = autoRestart_flag
    end
        

    if (displayStyle_flag == '=') then
        pb.displayStyle = 'new line'
    elseif (displayStyle_flag == '-') then
        pb.displayStyle = 'same line'
    end
    
    local nExtraTopBars = iff(pb.autoRestart, 6, 0)
    if (pb.displayStyle == 'new line') then
        io.write('\n' .. string.rep('-', nTotalBars+nExtraTopBars) .. '\n')
    end

    if pb.autoRestart then
        io.write(string.format('(%3d )', pb.nStarts))
    end
 

    -- 2. Starting bars
    pb.nBarsDisplayed = 0;
    io.write('|')
    io.flush()
    if (pb.nStepsDoneAtStart > 0) then
        pb.nBarsDisplayed = math.floor(pb.nStepsDoneAtStart/pb.stepsPerBar)
        
        io.write( string.rep('=', pb.nBarsDisplayed) )
        
        pb.laststr = '';
    end 
            
        
    if pb.allowBreakWithFile then

    end
        
        
end


progressBar.step = function(stepsDone_in)
    
    local pb = progressBar   
    if not stepsDone_in then
        pb.nStepsDone = pb.nStepsDone + 1
    else
        pb.nStepsDone = stepsDone_in
    end
    
    local barsCompleted = math.floor(pb.nStepsDone/pb.stepsPerBar)
    if (barsCompleted > pb.nBarsDisplayed) then
        pb.timeTaken_sec = pb.timer:time().real
            
        local nColumns = os.getenv('COLUMNS')
        
        if nColumns == nil then          
            nColumns = 90
            --pb.showTimeRemaining = false
        end
                
        pb.timeRemaing_sec = pb.timeTaken_sec/(pb.nStepsDone - pb.nStepsDoneAtStart) * (pb.nStepsTotal - pb.nStepsDone)
        pb.startedAtStr = iff(pb.nStepsDoneAtStart ==0, '', '[Started at ' .. tostring(nStepsDoneAtStart) .. ']: ')
        local stepsStr = 'Completed ' .. pb.startedAtStr  .. pb.nStepsDone .. '/' .. pb.nStepsTotal
        local elapStr = 'Elapsed: ' .. sec2hms(pb.timeTaken_sec) 
        local remStr =  '[Remaining: ' .. sec2hms(pb.timeRemaing_sec) .. ']'
        
        
        local barsToDisplay = barsCompleted - pb.nBarsDisplayed
        if barsToDisplay > 0 then
            pb.nBarsDisplayed = pb.nBarsDisplayed + barsToDisplay;
            if pb.showTimeRemaining then
                local dispStr = elapStr .. '. ' .. remStr;                      
                
                
                local space = string.rep(' ', pb.nTotalBars - pb.nBarsDisplayed ) .. '| ';
                backspace(pb.laststr);
             
                
                io.write(string.rep(pb.X, barsToDisplay));
                local textToShow = space .. dispStr
                
                local columnsLeft = nColumns - (pb.nBarsDisplayed + barsToDisplay) - 1
                
                if columnsLeft < #textToShow then
                    textToShow = string.sub(textToShow, 1, columnsLeft)
                end
                pb.laststr = textToShow
                io.write(pb.laststr);
                
            else
                io.write(string.rep(pb.X, barsToDisplay))
            end      
            io.flush()
        end
        
        if pb.autoRestart and (pb.nStepsDone >= pb.nStepsTotal) then
            progressBar.done()
            pb.nStarts = pb.nStarts + 1
                
            progressBar.init(pb.nStepsTotal, pb.nTotalBars, '-', pb.nStarts)
        end
        
    end
    
end
    


progressBar.done = function()
    local pb = progressBar
    if not pb.showTimeRemaining then
        pb.timeTaken_sec = pb.timer:time().real
        local completedStr = ' Completed in: ' .. sec2hms(pb.timeTaken_sec)  
        io.write(completedStr)
    end
        
    io.write('\n')
    if progressBar.allowBreakWithFile then
        if paths.filep(stop_file) then            
            os.rename(stop_file, stopping_file)            
            error('Stop.')
        end
    end
    
end


progressBar.test = function()

    local ntrials = 80
    local nstars = 40
    local startAt = 0
    io.write('\nTesting... ' .. ntrials ..  ' trials, ' .. nstars .. ' stars; starting at ' .. startAt);
--    progressBar.init({startAt, ntrials}, nstars, '=')
    progressBar.init(ntrials, nstars, '=', false)
    for i = startAt, ntrials do
        progressBar.step()
        sys.sleep(0.01)
    end
    progressBar.done();

--[[
    for _,ntrials in pairs({20, 40, 60}) do
        for _,nstars in pairs({10, 30, 50}) do
            for _,startAt in pairs({0 ,5}) do

                io.write('\nTesting... ' .. ntrials ..  ' trials, ' .. nstars .. ' stars; starting at ' .. startAt);
                progressBar.init({startAt, ntrials}, nstars, '=')
                for i = startAt, ntrials do
                    progressBar.step(i)
                    os.execute("sleep 0.01")
                end
                progressBar.done();
                
                os.execute("sleep 1")
                
            end            
        end
    end
    --]]            

    
end

--progressBar.test()
