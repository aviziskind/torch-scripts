table.tostring = function(tbl, indent)
    -- Print contents of `tbl`, with indentation.
 -- `indent` sets the initial level of indentation.
    
    if type(tbl) ~= 'table' then
        return tostring(tbl)
    end
            
    local str = ''
 
      if not indent then indent = 0 end
      for k, v in pairs(tbl) do
        local formatting = '  ' .. string.rep("  ", indent) .. k .. " : "
        if type(v) == "table" then
          str = str .. formatting .. '\n' .. table.tostring(v, indent+1)
        elseif type(v) == 'boolean' then
            str = str .. formatting .. tostring(v) .. '\n'
          --print(formatting .. tostring(v))		
        else
            str = str .. formatting .. v .. '\n'
          --print(formatting .. v)
        end
      end
    
    
    return str
end