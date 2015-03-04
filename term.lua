--[[ 
term={ 
        output=io.write, 
        clear = function () term.output("\027[2J") end, 
        cleareol = function () term.output("\027[K") end, 
        goto = function (l,c) term.output("\027[",l,";",c,"H") end, 
        goup = function (n) term.output("\027[",n or 1,";","A") end, 
        godown = function (n) term.output("\027[",n or 1,";","B") end, 
        goright = function (n) term.output("\027[",n or 1,";","C") end, 
        goleft = function (n) term.output("\027[",n or 1,";","D") end, 
        color = function (f,b) term.output("\027[",f,";",b,"m") end, 
        save = function () term.output("\027[s") end, 
        restore = function () term.output("\027[u") end, 
 } 
 
 term_example = function()
     term.clear() 
     term.goto(10,1) 
     term.cleareol() 
     term.goto(10,10) 
     term.output("hello!") 
     term.color(31,42) 
     term.output("bye!") 
     term.color(43,31) 
     term.output("tchau mesmo!") 
     term.color(0,0) 
     term.output("ok!") 
     term.goup(4) 
     term.goleft(8) 
     term.output("here") 
     term.save() 
     term.goto(2,3) 
     term.output("HERE") 
     term.restore() 
     term.output("DONE")
end

-- r, g and b are floats in [0;1] 
function term.color2(r,g,b) 
    r = math.floor(r * 5 + 0.5) 
    g = math.floor(g * 5 + 0.5) 
    b = math.floor(b * 5 + 0.5) 
    local color = 16 + r * 36 + g * 6 + b 
    term.output("\027[48;5;",color,"m") 
end 

function color_cube()
    print("Color cube, 6x6x6:") 
    for green=0,5 do 
        for red=0,5 do 
            for blue=0,5 do 
                term.color2(red / 5, green / 5, blue / 5) 
                term.output("  ") 
            end 
            term.output("\027[0m ") 
        end 
        term.output("\n") 
    end 
end
--]]