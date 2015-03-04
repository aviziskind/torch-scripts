weibull = function(beta, c, gamma)
    -- beta can be a table or a tensor.  c must be a tensor. gamma must be a number
    
    local y = torch.Tensor(c:numel())
    for i = 1, c:numel() do
        y[i] = (beta[1] - (beta[1]-gamma) * torch.exp (- (( (c[i]) /math.abs(beta[2])) ^(math.abs(beta[3])) ) ) );
    end
    return y
    
end