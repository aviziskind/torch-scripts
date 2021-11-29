require 'lfs'
paths.filesize = function(filename, units)
    if not paths.filep(filename) then
        return nil
    end
    local attrib = lfs.attributes(filename)
    local sz_bytes = attrib.size

    if not units then
        return sz_bytes
    end
    
    if units == 'KB' then
        return sz_bytes / 1024;
    elseif units == 'MB' then
        return sz_bytes / (1024*1024);
    elseif units == 'GB' then
        return sz_bytes / (1024*1024*1024);
    end 
    
end
   
   
   