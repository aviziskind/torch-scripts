-- use math.fmod instead
--math.mod = math.fmod
--[[
math.mod = function(a,b)
    return a - math.floor(a/b)*b 
end
--]]