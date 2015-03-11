local showLoading = false
local nameOfThisFile = 'load_all_torch_scripts.lua'
local myscripts_dir = paths.home .. '/Code/scripts/torch/'


runAllScriptsInFolder = function(baseFolder, level)
  
    local allNames = paths.dir(baseFolder)
  
    for _, name in pairs(allNames) do
            
        local str_prefix = string.rep('  ', level)
        
        local idx_ext = string.find(name, '.lua')
        if (idx_ext ~= nil) and not (name == nameOfThisFile) then  -- if is a .lua script, load it
            --print(script_name)
            if showLoading then
                io.write(string.format('%s%s \n', str_prefix, name))
            end
            
            dofile (baseFolder .. name)
        elseif (name ~= '.') and (name ~= '..') and paths.dirp(baseFolder .. name) then  -- if directory, recurse...
            if showLoading then
                io.write(string.format('%s  == %s == \n', str_prefix, name))
            end
            runAllScriptsInFolder(baseFolder .. name .. '/', level + 1)
        
            if showLoading then
                io.write(string.format('%s  ======== \n', str_prefix))
            end

            
        end
        
           
    end
end


runAllScriptsInFolder(myscripts_dir, 0)
