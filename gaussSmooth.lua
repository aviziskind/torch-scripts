---[[
gaussSmooth2D = function(Y, w, circularSmooth)
    if (w == 0) then
        return Y
    end    
    
    local n_std_gaussians = 4; -- how many std deviations of gaussian to actually implement
    local n_g = math.max(math.ceil(n_std_gaussians*w), 2)
    
    local m, n
    if Y:dim() == 2 then
        m,n = Y:size(1), Y:size(2)
    elseif Y:dim() == 3 then
        m,n = Y:size(2), Y:size(3)
    end
    
    local Ng = n_g*2+1
    local kern = image.gaussian(Ng, w / Ng, 1, 1);
    --[[
    g = gaussian( torch.range(-n_g, n_g ), 0, w)
    g:div( g:sum() )
    --]]
        
    local idx_vert
    local idx_horiz
    
    if circularSmooth then
        idx_vert = indexWrap(m, n_g)
        idx_horiz = indexWrap(n, n_g)
    else
        idx_vert = indexExtend(m, n_g)
        idx_horiz = indexExtend(m, n_g)
    end

    local Y_conv
    
    --print('ysize', Y:size())
    if Y:dim() == 2 then
        Y = Y:index(1, idx_vert):index(2, idx_horiz)        
        Y_conv = torch.conv2(Y, kern)
    elseif Y:dim() == 3 then
        kern = kern:reshape(1,Ng, Ng)
        --kern = torch.expand(kern, Y:size(1), Ng, Ng)
        
        --print('kern_size', kern:size())
        Y = Y:index(2, idx_vert):index(3, idx_horiz)        
        
        Y_conv = torch.conv3(Y, kern)
    end
    
    --print('y_conv_size', Y_conv:size())
    return Y_conv
   
    
end

indexWrap = function(N, n)
    return torch.cat( torch.cat(   torch.range(N-n+1, N), torch.range(1,N)), torch.range(1, n) ):long()
end

indexExtend = function(N, n)
    return torch.cat( torch.cat(   torch.ones(n)*1, torch.range(1,N)), torch.ones(n)*N ):long() 
end



-- function Y = myConv(X, c)
-- 
--     sizeX = size(x);
--     [L, ncols] = size(X);
--     rshp = length(size(X)) > 2;
--     Ly = L+length(c)-1;
--     
--     if rshp        
--         X = reshape(X, [L, ncols]);                
--     end
--     
--     Y = convmtx(c(:),L)*X;
-- 
--     if rshp
--         Y = reshape(X, [Ly, sizeX(2:end)]);
--     end    
--     
-- end

-- function Y = rowsOfX(X, rowIdx)
--     [n, ncols] = size(X);
--     sizeX = size(X);
--     X = reshape(X, [n, ncols]);
--     Y = X(rowIdx, :);
--     Y = reshape(Y, [length(rowIdx), sizeX(2:end)]);
-- end

--]]