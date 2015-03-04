subfolders = function(parentDir)
    
    if string.sub(parentDir, #parentDir, #parentDir) ~= '/' then
        parentDir = parentDir .. '/'
    end
        
    
    local ls_cmd = ' -d ' .. parentDir .. '*/ '
    local ls_output_test = sys.ls(ls_cmd)
    if string.find(ls_output_test, 'No such file or directory') then
        return {}
    else    
        local subfolders_str = sys.ls(ls_cmd .. ' |  xargs -n1 basename')
        return string.split(subfolders_str, '\n')
    end
        
    
end