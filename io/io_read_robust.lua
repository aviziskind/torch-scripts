
function io.read_robust(...)
    local s
    
    local arg = {...}    
    local function runIoRead()
        s = io.read(unpack(arg))
    end
        
    while s == nil do
	    pcall(runIoRead)
        if s == nil then
            io.write('[trying again]')
        end
	end
    --]]
    
    return s
end
