paths.nFilesMatching = function(str)
    local ls_results = sys.ls(str)
    if string.find(ls_results, 'No such file or directory') then
        return 0, {}
    end
    return string.nLines(ls_results), string.split(ls_results, '\n')
        
end