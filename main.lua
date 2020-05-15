require "test"
local ss=''
function love.load()
    if test then
        ss=test.about()
    end
end

function love.draw()
    love.graphics.print(ss,0,0)
end
