require 'nn'

nn.SSECriterion = function()  -- sum-squared error
    local crit = nn.MSECriterion()  -- mean-squared error, but don't do the size averaging at the end --> =sum-squared error
    crit.sizeAverage = false;
    return crit
end
