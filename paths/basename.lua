basename = function(fn, nrep)
    if not nrep then
        nrep = 1
    end
    local str = ''
    for i = 1,nrep do
        if i == 1 then
            str = paths.basename(fn)
        else
            str =  paths.basename(fn) .. '/' .. str
        end
        
        fn = paths.dirname(fn)
    end
    return str
end