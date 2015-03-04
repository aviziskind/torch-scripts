backspace = function(s)
    --input a string, (that has just been printed), or just the length of
    --the string, and this will erase it from the display (as long as we haven't gone to the next line)    
    if type(s) == 'string' then
        n = #s
    elseif type(s) == 'number' then
        n = s;
    end
         
    io.write( string.rep( string.char(8), n))
end
