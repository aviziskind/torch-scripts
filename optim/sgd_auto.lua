require 'optim'
--[[ A plain implementation of SGD

ARGS:

- `opfunc` : a function that takes a single input (X), the point
             of a evaluation, and returns f(X) and df/dX
- `x`      : the initial point
- `config` : a table with configuration parameters for the optimizer
- `config.learningRate`      : learning rate
- `config.learningRateDecay` : learning rate decay
- `config.weightDecay`       : weight decay
- `config.momentum`          : momentum
- `config.dampening`         : dampening for momentum
- `config.nesterov`          : enables Nesterov momentum
- `state`  : a table describing the state of the optimizer; after each
             call the state is modified
- `state.learningRates`      : vector of individual learning rates

RETURN:
- `x`     : the new x vector
- `f(x)`  : the function, evaluated before the update

(Clement Farabet, 2012)
]]
function optim.sgd_auto(opfunc, x, config, state)
        -- (0) get/update state
    config = config or {}
    state = state or config
    local lr = config.learningRate or 1e-3
    local lrd = config.learningRateDecay or 0
    local wd = config.weightDecay or 0
    local mom = config.momentum or 0
    local damp = config.dampening or mom
    local nesterov = config.nesterov or false
    local lrs = config.learningRates
    state.evalCounter = state.evalCounter or 0
    local nevals = state.evalCounter
    local adaptiveMethod = config.adaptiveMethod
    assert(not nesterov or (mom > 0 and damp == 0), "Nesterov momentum requires a momentum and zero dampening")

    local cur_idx = _idx_

    -- (1) evaluate f(x) and df/dx
    local fx,dfdx = opfunc(x)

    -- (2) weight decay
    if wd ~= 0 then
        dfdx:add(wd, x)
    end

    -- (3) apply momentum
    if mom ~= 0 then
        local mom_use = mom 
        if state.evalCounter < 500 then
            mom_use = 0.5 -- start off with momentum slowly to avoid instability
        end
        
        if not state.dfdx then
            state.dfdx = torch.Tensor():typeAs(dfdx):resizeAs(dfdx):copy(dfdx)
        else
            state.dfdx:mul(mom_use):add(1-damp, dfdx)
        end
        if nesterov then
            dfdx:add(mom_use, state.dfdx)
        else
            dfdx = state.dfdx
        end
    end

    -- (4) learning rate decay (annealing)
    local clr = lr / (1 + nevals*lrd)

    -- (5) parameter update with single or individual learning rates



    if adaptiveMethod then
        local adaptiveMethod_str = string.lower(adaptiveMethod)
        local isAdadelta = adaptiveMethod_str == 'adadelta'
        local isRMSprop  = adaptiveMethod_str == 'rmsprop'
        local isVSGD     = adaptiveMethod_str == 'vsgd'

        if isAdadelta or isRMSprop then

            if not state.adaptive_init then
                -- initialize variables
                state.adaptive_init = 1

                state.accSquaredGradients = torch.Tensor():typeAs(x):resizeAs(dfdx):zero();

                state.sqrGradient = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.curUpdate = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.rmsGradient = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.curLearningRate = torch.Tensor():typeAs(x):resizeAs(dfdx)
                if isAdadelta then
                    state.sqrUpdate = torch.Tensor():typeAs(x):resizeAs(dfdx)
                    state.rmsUpdate = torch.Tensor():typeAs(x):resizeAs(dfdx)
                    state.accSquaredUpdates = torch.Tensor():typeAs(x):resizeAs(dfdx):zero();

                end

                state.stateCounter2 = 1;
                state.updateCounter = 0;
            end
            --State = state
            local rho = config.rho or 0.95
            local epsilon = config.espsilon or 1e-6;
            local updateEveryN = config.updateEveryN or 1

            local updateLearningRatesNow = false;
            if state.stateCounter2 >= updateEveryN or (state.evalCounter < 200) then
                updateLearningRatesNow = true; --state.evalCounter < 100 or math.modf(state.evalCounter, updateEveryN) == 0 or true
                state.stateCounter2 = 0
            end
            --local updateLearningRatesNow = state.evalCounter < 100 or math.modf(state.evalCounter, updateEveryN) == 0 or true

            if updateLearningRatesNow then
                -- accumulate (squared) gradient
                state.sqrGradient:copy(dfdx):cmul(dfdx)
                state.accSquaredGradients:mul(rho):add ( state.sqrGradient:mul(1-rho) )

                state.rmsUpdate:copy(state.accSquaredUpdates):add(epsilon):sqrt()
                if isAdadelta then
                    -- compute update
                    state.rmsGradient:copy(state.accSquaredGradients):add(epsilon):sqrt()
                    state.curLearningRate:copy(state.rmsUpdate):cdiv(state.rmsGradient):mul(-1)
                    state.curUpdate:copy(dfdx):cmul(state.curLearningRate)

                elseif isRMSprop then
                    state.curUpdate:copy(dfdx):cdiv(state.rmsGradient):mul(-1) 
                end

            end


            if updateLearningRatesNow then
                state.sqrUpdate:copy(state.curUpdate):cmul(state.curUpdate)
                state.accSquaredUpdates:mul(rho):add(  state.sqrUpdate:mul(1-rho) )
                state.updateCounter = state.updateCounter + 1
            end
            x:add(state.curUpdate)

            state.stateCounter2 = state.stateCounter2 + 1


        elseif isVSGD then
            if not state.vSGD_init then
                state.vSGD_init = 1

                --state.h_fd = 
                state.ones = torch.Tensor():typeAs(x):resizeAs(dfdx):fill(1)

                state.shifted_x = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.dfdx_plus_delta = torch.Tensor():typeAs(x):resizeAs(dfdx)
                
                state.g_bar = torch.Tensor():typeAs(x):resizeAs(dfdx):zero()
                state.v_bar = torch.Tensor():typeAs(x):resizeAs(dfdx):zero()
                state.h_fd_bar = torch.Tensor():typeAs(x):resizeAs(dfdx):zero()
                state.v_fd_bar = torch.Tensor():typeAs(x):resizeAs(dfdx):zero()
                state.tau = torch.Tensor():typeAs(x):resizeAs(dfdx):fill(10)
                
                state.delta = torch.Tensor():typeAs(x):resizeAs(dfdx):zero()
                state.gradient = torch.Tensor():typeAs(x):resizeAs(dfdx):zero()
                state.gradient_shifted = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.sqrGradient = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.h_fd = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.h_fd_sqr = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.g_bar_sqr = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.denom = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.eta_star = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.curUpdate = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.tauKeepFactor = torch.Tensor():typeAs(x):resizeAs(dfdx)
                state.tauDecayFactor = torch.Tensor():typeAs(x):resizeAs(dfdx)

                state.stateCounter2 = 1;
                state.updateCounter = 0;
                
                --state.copies = {}
                --state.nBootSamplesLeft = 10
                
                
            end
            State = state
    
            local epsilon = 1e-4;
            local updateEveryN = config.updateEveryN or 1

            local updateLearningRatesNow = true;
            local updateParametersNow = (state.evalCounter > 10)
            if state.stateCounter2 >= updateEveryN or (state.evalCounter < 10) then
                updateLearningRatesNow = true; --state.evalCounter < 100 or math.modf(state.evalCounter, updateEveryN) == 0 or true
                state.stateCounter2 = 0
            end
            
            
            print10 = function(x, x_name)
                print(x_name)
                print(x[{{1,5}}])
                print(x:min())
                print(x:max())
            end
            --local updateLearningRatesNow = state.evalCounter < 100 or math.modf(state.evalCounter, updateEveryN) == 0 or true
            local nBatch = 1
            if updateLearningRatesNow then
                
                
                state.tauKeepFactor:copy(state.ones):cdiv(state.tau)   -- 1/tau
                state.tauDecayFactor:copy(state.tauKeepFactor):mul(-1):add(1)   -- 1 - 1/tau
                
                state.gradient:copy(dfdx) -- this will be overwritten when we calculate the shifted gradient

                if state.evalCounter == 0 then
                    state.delta:copy(state.gradient):mul(1e-2) -- = torch.Tensor(state.gradient) 
                else
                    state.delta:copy(state.g_bar)  
                end
                state.shifted_x:copy(x):add(state.delta)

                _idx_ = cur_idx

                local _, dfdx_plus_delta = opfunc(state.shifted_x)
                state.gradient_shifted:copy(dfdx_plus_delta)

                -- compute finite-difference curvature: h_fd := |(grad_x - grad_(x+delta))/delta |
                state.h_fd:copy(state.gradient):add(-1, state.gradient_shifted):cdiv(state.delta):abs() -- h_fd (finite difference curvatures h_(fd)
                --[[
                if state.evalCounter == 0 then
                    print10(state.gradient, 'gradient')
                    print10(state.gradient_shifted, 'gradient_shifted')
                    print10(state.delta, 'delta')
                    print10(state.h_fd, 'h_fd')
                    
                end
                --]]
                state.sqrGradient:copy(state.gradient):cmul(state.gradient)
                state.h_fd_sqr:copy(state.h_fd):cmul(state.h_fd)

                -- update moving averages
                -- g_bar := (1-1/tau)*g_bar  + (1/tau)*<gradient>
                -- v_bar := (1-1/tau)*v_bar  + (1/tau)*<gradient^2>
                -- h_fd_bar := (1-1/tau)*h_fd_bar  + (1/tau)*<h_fd>
                -- v_fd_bar := (1-1/tau)*v_fd_bar  + (1/tau)*<h_fd^2>
                state.g_bar:cmul(state.tauDecayFactor):add( state.gradient:cmul(state.tauKeepFactor) ):add(epsilon)  -- gradient is now multiplied by a factor
                state.v_bar:cmul(state.tauDecayFactor):add( state.sqrGradient:cmul(state.tauKeepFactor) ):add(epsilon) -- sqrGradient now multiplied
                state.h_fd_bar:cmul(state.tauDecayFactor):add( state.h_fd:cmul(state.tauKeepFactor) ):add(epsilon)
                state.v_fd_bar:cmul(state.tauDecayFactor):add( state.h_fd_sqr:cmul(state.tauKeepFactor) ):add(epsilon)

                
                if nBatch == 1 then
                    state.eta_star:cmul(state.g_bar_sqr):cdiv(state.v_bar)
                elseif nBatch > 1 then
                    state.denom:copy(state.g_bar_sqr):mul(nBatch-1):add(state.v_bar) 
                    state.eta_star:cmul(state.g_bar_sqr):mul(nBatch):cdiv(state.denom)
                end

                -- estimate learning rate: eta_star := h_fd_bar/v_fd_bar * ( n*g_bar^2 / (v_bar + (n-1)*(g_bar^2) ) )
                state.g_bar_sqr:copy(state.g_bar):cmul(state.g_bar)
                state.eta_star:copy(state.h_fd_bar):cdiv(state.v_fd_bar)
                
                -- update memory size:  tau := (1 - g_bar^2/v_bar)*tau + 1
                state.tau:copy( state.g_bar_sqr):cdiv(state.v_bar):mul(-1):add(1):cmul(state.tau):add(1)

                if state.evalCounter == 0 then
                    StateCopies = {}
                end
                if state.evalCounter < 5 then
                    StateCopies[state.evalCounter] = table.copy(state)
                end


                -- update parameter: theta := theta - eta_star*gradient   [[ for n = 1 ]]
                if updateParametersNow then
                    state.curUpdate:copy(dfdx):cmul(state.eta_star):mul(-1)
                    x:add(state.curUpdate)
                    
                    state.updateCounter = state.updateCounter + 1
                end
                
                
            end
            
        else -- if not adadelta, rmsprop or vSGD
            print(adaptiveMethod)
            error('Unknown adaptive method')
        
        end 
        

    elseif lrs then
        if not state.deltaParameters then
            state.deltaParameters = torch.Tensor():typeAs(x):resizeAs(dfdx)
        end
        state.deltaParameters:copy(lrs):cmul(dfdx)
        x:add(-clr, state.deltaParameters)

    else
        x:add(-clr, dfdx)
    end

    -- (6) update evaluation counter
    state.evalCounter = state.evalCounter + 1

    -- return x*, f(x) before optimization
    return x,{fx}
end
