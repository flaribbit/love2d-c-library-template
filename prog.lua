package.cpath='/data/data/org.love2d.android.embed/files/save/archive/lib?.so;'..package.cpath
love.filesystem.write("libtest.so", love.filesystem.read("libtest.so"))
require "test"
local ss=''
function love.load()
    if test then
        ss=test.about()
    end
end

function love.draw()
    love.graphics.print(ss,0,100)
end
