table.mergeTables = function(treatAllAsTables, ...)
   local all_tables = {...}   
   
   local nTables = #all_tables
   local tbl_master = {}
   
   local insertNonIndexedArrayAsIndivEntry = treatAllAsTables
   
   for i = 1,nTables do
       
        local tbl_i = all_tables[i]
        
        local nTotal = table.length(tbl_i)  -- handles non-indexed arrays
        local nArray = #tbl_i
        

        if nTotal > nArray then  -- struct/table (have non-array indices)
            if insertNonIndexedArrayAsIndivEntry then
                --tbl_i = {tbl_i}
                
                table.insert(tbl_master, tbl_i)
                --for i,v in ipairs(tbl_i) do
                    --table.insert(tbl_master, v)
                --end

            else 
                --error('Using non-indexed array')
                for k,v in pairs(tbl_i) do
                    tbl_master[k] = v
                end

            end
        else   -- indexed array
        
            for i,v in ipairs(tbl_i) do
                table.insert(tbl_master, v)
            end
            
        end
           
   end
   
   
   return tbl_master
     
end

-- the difference between these two functions is how they handle non-indexed tables.
table.mix = function(...)
    -- this function mixes together all contents of the input tables.
    -- so tables with the same fieldnames overwrite each other. (Good for opts)
   local all_tables = {...}   
   local treatAllAsTables = false
   return table.mergeTables(treatAllAsTables, unpack(all_tables))
end

table.merge = function(...)
    -- this function joins together a sequence of tables.
    -- non-indexed tables are inserted into the table as their own table
    -- (Good for collecting a sequence of options).
   local all_tables = {...}   
   local treatAllAsTables = true
   return table.mergeTables(treatAllAsTables, unpack(all_tables))
end

--[[
--to see the difference, try the following two.
return table.merge({a=1,b=2, 'A', 'B', 'C'}, {c=3}, {d=4, a=5, 'D'}, {'E', 'F'}, {'G'})
return table.mix(  {a=1,b=2, 'A', 'B', 'C'}, {c=3}, {d=4, a=5, 'D'}, {'E', 'F'}, {'G'})

--]]