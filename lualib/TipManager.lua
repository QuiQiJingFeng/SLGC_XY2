local HardWareUtil = require "HardWareUtil"
local skynet = require "skynet"
local super = require "commands.base"
local TipManager = class("TipManager", super)

function TipManager:Check(num,filter)
    game.dict:ChangeDict("ST_11")
    local rect = {240,255,557,304}
    for i=1,num do
        local text = game.dmcenter:Ocr(rect[1],rect[2],rect[3],rect[4],"ffff00-101010", 1)
        local find = string.find(text,filter)
        if find then
            return true
        end
        skynet.sleep(10)
    end
    
end

return TipManager