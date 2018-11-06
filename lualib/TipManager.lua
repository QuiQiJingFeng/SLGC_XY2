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

function TipManager:CheckYellowArea()
    game.dict:ChangeDict("ST_B_11")
    local list
    for i=1,5 do
        list = game.dmcenter:GetWordsNew(135,200,362,415, "ffff00-000000", 1.0)
        if #list > 0 then
            break
        end
    end

    if #list <= 0 then
        game.log.info("没有找到黄色提示")
        return
    end
    --FYD --TODO
    
    while true do
        if not list[1] then
            game.log.warning("没有在指定的区域,黄色提示无效")
            return
        end
        local pos = list[1].pos
        if pos.x < 100 or pos.x > 600 or pos.y < 100 or pos.y > 600 then
            table.remove(list,1)
        else
            break
        end
    end


    local pos = list[1].pos
    --TODO
    local rect = _rect(pos,50)
    --获取深色颜色块
    local color = "362f1b-101010|433327-101010"
    local npos = game.dmcenter:FindColorBlock(rect[1], rect[2], rect[3], rect[4], color, 1, 1000, 50, 50)
    if npos.x == 0 and npos.y == 0 then
        game.log.warning("没有找到深色颜色块,黄色提示无效")
        return
    end

    local obj = list[1]
    skynet.error("检测到黄色提示->",obj.word)

    obj.pos.x = obj.pos.x + math.random(10,50)
    obj.pos.y = obj.pos.y + math.random(3,8)
    HardWareUtil:MoveAndClick(obj.pos)
    skynet.sleep(100)
end

return TipManager