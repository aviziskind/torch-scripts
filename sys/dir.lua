sys.dir = function(folder)
    
    --[[
    fileArgs = fileArgs or ''
    if string.sub(folder, #folder, #folder) ~= '/' then
        folder = folder .. '/'
    end
    --]]
    
    
    local ls_output = sys.ls(folder)
    
    if string.find(ls_output, 'No such file or directory') then
        return {}
    else
        ls_output = sys.ls(folder .. '| xargs -n1 basename')
        return string.split(ls_output, '\n')
    end
    

end