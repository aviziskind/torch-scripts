gaussian = function(x, mu, sigma)
    
    local coeff = 1/(math.sqrt(2*math.pi*sigma^2))
    
    local type_x = getType(x)
    local exp_term
    if type_x == 'number' then
    
        exp_term = math.exp( -((x-mu)^2)/(2*sigma^2))
    elseif string.sub(type_x, 1, 5) == 'torch' then
        
        local x_mu = x - mu
        exp_term = torch.exp( -torch.cmul(x_mu, x_mu) /(2*sigma^2) )
            
    end
    
    return exp_term * coeff
    
    
end
