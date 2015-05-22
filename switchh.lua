function switchh(x, cases, vals)
--[[
    This function is a way to reduce code clutter by reducing multiple lines into 1:
 Instead of: 
         switch x
             case cases{1}, y = vals(1);
             case cases{2}, y = vals(2);
             otherwise,     y = vals(3);
         end
 
    You can just write:
         y = switchh(x, cases, vals);
 
    see also the "iff" function which allows a similar shorthand for 'if' cases

    If you know that x will match one of the values in 'cases', then you should 
    make length(vals) == length(cases).
    If there is a possibility that x will match none of the values in 'cases'
    and you want to add an effective 'otherwise' option (as in the example above), 
    then you should make length(vals) == length(cases) + 1. 
    The last value in vals should be the  'otherwise' value.
    Note: both "cases" and "vals" can be either vectors or cell arrays.
    If x is a string, then "cases" should be a cell array where each entry
    is either a string or a cell array of strings.
--]]
    local handleNoMatch = #vals == #cases + 1
    
    if (#vals ~= #cases) and not handleNoMatch then
        error('Number of possible outputs must equal number of cases (or # cases + 1)');
    end      
    
    local idx
    for i,v in ipairs(cases) do
        if isequal(x, v) then
            idx = i
            break;
        end
    end
    if not idx then
        if handleNoMatch then
            idx = #vals
        else
            error('Input did not match any of the cases, and no "otherwise" value was provided')
        end    
    end
    
    return vals[idx]
     
    
end

