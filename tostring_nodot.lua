tostring_nodot = function(n)
    local n_str = tostring(n)
    n_str = string.gsub(n_str, '[.]', 'o') 
    n_str = string.gsub(n_str, '0o', 'o')
    return n_str
end