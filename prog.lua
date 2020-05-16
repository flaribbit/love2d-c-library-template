package.cpath='/sdcard/?.so;/sdcard/lib?.so;'..package.cpath
require "test"
local ss=''
function love.load()
    if test then
        ss=test.about()
    end
end

function love.draw()
    love.graphics.print(ss,0,0)
    love.graphics.print('getUserDirectory: '..love.filesystem.getUserDirectory(),0,20)
    love.graphics.print('getSaveDirectory: '..love.filesystem.getSaveDirectory(),0,40)
    love.graphics.print('getWorkingDirectory: '..love.filesystem.getWorkingDirectory(),0,60)
    love.graphics.print('getAppdataDirectory: '..love.filesystem.getAppdataDirectory(),0,80)
end
