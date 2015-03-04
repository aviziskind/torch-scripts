createFolder = function(dir_name)
    -- creates a folder if it doesn't exist (along with any necessary parent folders)
    if not paths.dirp(dir_name) then
        print('Creating directory: '.. dir_name)
        os.execute('mkdir -p '..dir_name)
    end
end