local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)
--TODO
local CONVERT_NAMES = {
    ["金銮殿"] = { name = "皇宫",x=139,y=59},
    ["药店"] = {name = "洛阳城",x=163,y=164},
    ["杂货店"] = {name = "长安城",x=90,y=155}
}

--1、检查当前位置是否有旗,如果有则跳过并返回true
--如果没有则做个旗,并返回true
function cmd:Execute()
    local data = game.map:GetCurAreaAndPos()
    if CONVERT_NAMES[data.name] then
        data = CONVERT_NAMES[data.name]
    end
    game.map:CloseAllMap()
    game.map:OpenBigMap()
    game.map:OpenSmallMapFromBigMap(data.name)
    local pixelPos =  game.map:ConvertToWordSpace(data.name, data, true)
    --将鼠标移动到不覆盖旗帜的位置
    HardWareUtil:MoveTo(_p(pixelPos.x+math.random(30,50),pixelPos.y+math.random(30,50)))
    local path = "11.bmp|12.bmp"
    local rect = _rect(pixelPos,30)
    local list = self:RepeatFindEx(5,rect[1],rect[2],rect[3],rect[4], path, "020202", 1.0, 0)
    if #list > 0 then
        game.log.info("当前位置已经有飞行旗了")
        game.map:CloseAllMap()
        return true
    end
    --开始立FLAG
    game.log.info("开始立插旗 ^o_o^")
    HardWareUtil:MoveTo(_p(math.random(500,600),math.random(400,600)))
    local result = self:MakeFlag()
    game.bag:CloseBag()
    game.map:CloseAllMap()
    return result
end

function cmd:MakeFlag()
    --打开任务栏1
    game.bag:OpenBag(1)
    local CONTENT_RECT = {25,290,345,510}
    --获取获取所有的孔明灯 以及详细信息
    local list = game.item:Distinguish("孔明灯",CONTENT_RECT)
    table.sort(list,function(a,b) 
        return a.num < b.num
    end)
    --循环找到一个 次数大于0 并且num <8的
    local obj
    for i,v in ipairs(list) do
        if v.num < 8 and v.times > 0 then
            obj = v
        end
    end
    if not obj then
        return game.log.warning("没有足够的孔明灯可以使用了")
    end
    obj.num = obj.num + 1
    HardWareUtil:MoveToRightClick(obj)
    if game.tip:Check(10,"做好了") then
        return true
    end
    self:searchAndClickText("00d011-101010", "新增路标")
    return true
end

return cmd
