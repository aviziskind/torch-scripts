require 'nn'

nn.criterion_batchForward = function(criterion, outputs, targets)
    local N = outputs:size(1)
    local loss_eachOutput = torch.Tensor(N)
    for i = 1,N do
        loss_eachOutput[i] = criterion:forward(outputs[i], targets[i])
    end
    local loss = loss_eachOutput:mean()
    return loss, loss_eachOutput
end