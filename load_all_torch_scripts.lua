local showLoading = false
local nameOfThisFile = 'load_all_torch_scripts.lua'
local myscripts_dir = ''
if paths.dirp('/home/avi') or paths.dirp('/home/fhwa/') then
    myscripts_dir = '/f/scripts/torch/'
elseif paths.dirp('/home/ziskind') then
    myscripts_dir = '/home/ziskind/f/scripts/torch/'
end

local dirsToSkip = {['.git'] = 1}
local filesLoadedCount = 0;

runAllScriptsInFolder = function(baseFolder, showLoading, level)
    if not level then
        level = 0;
    end
    if not showLoading then
        showLoading = false;
    end
    if level == 0 then
        filesLoadedCount = 0;
    end
    if level == 0 and not showLoading then
        io.write('Loading all scripts in "' .. baseFolder .. '" ...')
    end
  
    local allNames = paths.dir(baseFolder)
    if allNames == nil then
        error('Nothing in ' .. baseFolder)
    end
  
    for _, name in pairs(allNames) do
            
        local str_prefix = string.rep('  ', level)
                
        local idx_ext = string.find(name, '[.]lua$')  -- put [] around . so that looks for actual ".", not any letter.  $ = end of string
        
        if (idx_ext ~= nil) and not (name == nameOfThisFile) then  -- if is a .lua script, load it
            --print(name)
            if showLoading then
                io.write(string.format('%s%s \n', str_prefix, name))
            end
            
            dofile (baseFolder .. name)
            filesLoadedCount = filesLoadedCount + 1;
            
        elseif (name ~= '.') and (name ~= '..') and paths.dirp(baseFolder .. name) and not (dirsToSkip[name]) then  -- if directory, recurse...
            if showLoading then
                io.write(string.format('%s  == %s == \n', str_prefix, name))
            end
            runAllScriptsInFolder(baseFolder .. name .. '/', showLoading, level + 1)
        
            if showLoading then
                io.write(string.format('%s  ======== \n', str_prefix))
            end

            
        end
        
           
    end
    
    if level == 0 and not showLoading then
        io.write(string.format(' done (loaded %d scripts)\n', filesLoadedCount))
    end

end


--print(myscripts_dir)
runAllScriptsInFolder(myscripts_dir, showLoading, 0)
