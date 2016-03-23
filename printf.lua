--[[
 printf = function(s,...)
   return io.write(s:format(...))
 end 
--]]

function printf(...)
   local function wrapper(...) io.write(string.format(...)) end
   local status, result = pcall(wrapper, ...)
   if not status then error(result, 2) end
end


----- printf in color
----- cprintf.red( ... )   -- regular red text
----- cprintf.Red( ... )   -- bold red text

colorize_write = require 'trepl.colorize'

local  colorize_allColors = {'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow', 
                             'Black', 'Blue', 'Cyan', 'Green', 'Magenta', 'Red', 'White', 'Yellow', 'none'}
cprintf = {}
for col_i, color in ipairs(colorize_allColors) do    
         
    cprintf[color] = function(...)
       local function wrapper(...) io.write( colorize_write[color]( string.format(...)) ) end
       local status, result = pcall(wrapper, ...)
       if not status then error(result, 2) end
    end

end