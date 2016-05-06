paths.verifyFolderExists = function(dirname, createIfDoesntExist)
    
    -- if provided with the name of a file, redirect to its parent folder
    if paths.removeFileExtension(dirname) ~= dirname then   --is the name of a file
    --string.find(  string.sub(dirname, #dirname - 5, #dirname), '[.]') then  -- ie. has filename at end
        dirname = paths.dirname(dirname)
    end
    
    if not paths.dirp(dirname) then
        if createIfDoesntExist then
            io.write(string.format('Path does not exist: %s. Creating now :\n', dirname))
            paths.createFolder(dirname)
        else
            error(string.format('Error: Path does not exist: %s', dirname))
        end
    end        
end
