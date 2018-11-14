local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)

function cmd:Execute()
        -- game.map:GoTo("长安",_p(374, 16),false,true)
        -- game.map:ChatPos(_p(374, 16))
        -- game.map:GoTo("长安",_p(215, 181),false,true)
        -- game.bag:OpenBag("t")
        -- local list = game.item:Distinguish("昆仑镜",{0, 0, 800, 600})
        -- local obj = list[1]
        -- HardWareUtil:MoveToRightClick(obj)
        -- skynet.sleep(100)
        -- local text = self:ParseTask("职业任务")
        -- local iter = string.gmatch(text,"(%d+)")
        -- local x = tonumber(iter())
        -- local y = tonumber(iter())
        -- game.map:GoTo("长安",_p(x, y))
        -- game.map:ChatPos(_p(x, y))
        -- game.cmdcenter:Execute("battle","FIGHT")

        -- local text = self:ParseTask("职业任务")
        -- local iter = string.gmatch(text,"(%d+)")
        -- local x = tonumber(iter())
        -- local y = tonumber(iter())
        -- game.map:GoTo("洛阳城",_p(x, y))
        -- game.map:ChatPos(_p(x, y))
        -- HardWareUtil:MoveTo(_p(700,50))
        -- local obj = self:RepeateSearchWords(10,"ST_11","文采不错",100, 125, 650, 500,"00d011-101010",1)
        -- if not obj then
        --     game.log.error("开始答题失败")
        -- else
        --     HardWareUtil:MoveAndClick(obj)
        -- end
        -- skynet.sleep(100)
        -- HardWareUtil:MoveTo(_p(700,50))
        -- skynet.sleep(10)
        -- HardWareUtil:MoveTo(_p(700,55))
        -- skynet.sleep(100)
    
        if not self:Dati() then
            game.log.error("答题失败")
        end
        game.map:GoTo("长安",_p(374, 16),false,true)
        game.map:ChatPos(_p(374, 16))
        return true
end

function cmd:Dati()
    while true do
        game.dict:ChangeDict("ST_11")
        local list = game.dmcenter:GetWordsNew(133, 232, 662,378,"00d011-101010|ffffff-000000",1)
        if #list <= 0 then
            game.log.debug("识别诗词完毕,没有找到新的诗词")
            return true
        end
        if string.find(list[1].word,"真厉害") then
            return true
        end
        local value = game.cmdcenter:Execute("dati",list[1].word)
        skynet.sleep(100)
        local finish = false
        for i,v in ipairs(list) do
            if string.find(v.word,value) then
                HardWareUtil:MoveAndClick(v)
                finish = true
            end
        end
        if not finish then
            game.log.debug("没有找到匹配的诗词")
            return
        end
        skynet.sleep(50)
        HardWareUtil:MoveTo(_p(600,580))
        skynet.sleep(200)
    end
end

--[[

function cmd:Execute()
    self:GoTo("长安",_p(374, 16))
    --对话鬼族使者
    game.cmdcenterExecute("0013", _p(374, 16))
    skynet.sleep(100)
    --移动到昆仑镜的使用位置
    self:GoTo("长安", _p(215, 181))

    HardWareUtil:KeyPad("alt+e")
    local path = "task_icon_close.bmp|task_icon_open.bmp"
    local list = self:RepeateFindEx(10,300, 300, 600, 500, path, "020202",1,0)
    if #list <= 0 then
        game.log.debug("没有找到任何一张图片")
        return false
    end
    if #list >= 2 then
        game.log.debug("失败,找到的图片多于两张")
        return false
    end
    local obj = list[1]
    if obj.index == 0 then
        obj.x = obj.x + 20
        HardWareUtil:MoveAndClick(obj)
        skynet.sleep(50)
    end

    --查找到昆仑镜的图片 右键点击
    local pos = self:RepeateFind(10,0, 0, 800, 600, "kunlunjing.bmp", "020202",1,0)
    if not pos then
        game.log.warning("没有找到昆仑镜")
        return
    end
    HardWareUtil:MoveToRightClick(pos)
    skynet.sleep(200)

    local text = self:ParseTask("职业任务")
    local iter = string.gmatch(text,"(%d+)")
    local x = tonumber(iter())
    local y = tonumber(iter())
    self:GoTo("长安", _p(x, y))
    --寻找武状元
    --对话武状元
    game.cmdcenterExecute("0013",_p(x, y))
    skynet.sleep(50)
    --战斗检测
    if not game.cmdcenter:TestExecute("0001","FIGHT") then
        game.log.error("战斗检测失败")
    end

    local text = self:ParseTask("职业任务")
    local iter = string.gmatch(text,"(%d+)")
    local x = tonumber(iter())
    local y = tonumber(iter())
     --寻路文状元
     self:GoTo("洛阳城", _p(x, y))
     --对话文状元
     game.cmdcenterExecute("0013",_p(x, y))

    local find = false
    for i=1,5 do
        if self:searchAndClickText("00d011-101010","文采不错") then
            find = true
            break
        end
        skynet.sleep(10)
    end
    if not find then
        game.log.debug("开始答题失败")
        return
    end
    HardWareUtil:MoveTo(_p(400,580))
    skynet.sleep(100)
    
    if not self:Dati() then
        game.log.error("答题失败")
    end
    self:GoTo("长安",_p(374, 16))
    --对话鬼族使者
    game.cmdcenterExecute("0013", _p(374, 16))
    return true
end

function cmd:Dati()
    while true do
        game.dict:ChangeDict("ST_11")
        local list = game.dmcenter:GetWordsNew(133, 232, 662,378,"00d011-101010|ffffff-000000",1)
        if #list <= 0 then
            game.log.debug("识别诗词完毕,没有找到新的诗词")
            return true
        end
        if string.find(list[1].word,"真厉害") then
            return true
        end
        local value = game.cmdcenter:Execute("dati",list[1].word)
        local finish = false
        for i,v in ipairs(list) do
            if string.find(v.word,value) then
                HardWareUtil:MoveAndClick(v.pos)
                finish = true
            end
        end
        if not finish then
            game.log.debug("没有找到匹配的诗词")
            return
        end
        skynet.sleep(50)
        HardWareUtil:MoveTo(_p(600,580))
        skynet.sleep(200)
    end
end
]]

return cmd