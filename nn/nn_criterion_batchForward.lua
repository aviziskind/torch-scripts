require 'nn'

nn.criterion_batchForward = function(criterion, outputMatrix_train, target_train)
    local N = outputMatrix_train:size(1)
    local loss = 0
    for i = 1,N do
        loss = loss + criterion:forward(outputMatrix_train[i], target_train[i])
    end
    loss = loss / N
    return loss
end