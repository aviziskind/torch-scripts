getType = function(X)
    --X_copy = X
    local type_str = type(X)
    
    if type_str == 'userdata' then
        local torch_type = torch.typename(X)
        if torch_type then
            --type_str = X:type()
            type_str = torch_type
        else
            X_copy = X
            error('Not a standard lua type or a torch type ')
        end
        
    end
    return type_str
    
end
