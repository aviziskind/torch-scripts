torch.isnan = function(x)
    x_vec = x:view(-1)
    b = torch.ByteTensor(x:numel())
    for i = 1,x:numel() do
        b[i] = isnan(x_vec[i]) and 1 or 0
    end
    return b:reshape(x:size())

end
