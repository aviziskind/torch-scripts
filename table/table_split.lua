function table.split(tbl,idxSplit)
   local t1 = {}
   local t2 = {} -- pos,tab = 0, {}
   for idx,val in ipairs(tbl) do
       if idx < idxSplit then
            table.insert(t1, val)
        else
            table.insert(t2, val)
        end
   end
   return t1, t2
end