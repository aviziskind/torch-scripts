require 'lfs'
paths.filedate = function(filename)
    if not paths.filep(filename) then
        return nil
    end
   local attrib = lfs.attributes(filename)
   local datenum = attrib.modification
   return datenum
    
end