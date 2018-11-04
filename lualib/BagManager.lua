local HardWareUtil = require "HardWareUtil"
local skynet = require "skynet"
local super = require "commands.base"
local BagManager = class("BagManager", super)
local RECT = {330,290,377,488}
--打开指定ID的物品栏,确认打开后返回
--id 1,2,3,4,t
function BagManager:OpenBag(id)
    local path = "bag/t_open.bmp|bag/t_close.bmp"

    local list = self:RepeatFindExS(1,RECT[1],RECT[2],RECT[3],RECT[4], path, "020202", 1.0, 0)
    if #list <= 0 then
        --如果物品栏处于关闭状态
        HardWareUtil:KeyPad("alt+e")
    end
    local list = {
        {pos = _p(350,316)},
        {pos = _p(350,350)},
        {pos = _p(350,386)},
        {pos = _p(350,421)},
        {pos = _p(350,455)},
    }
    local array = {}
    for i=1,4 do
        table.insert(array,"bag/"..i.."_close.bmp")
        table.insert(array,"bag/"..i.."_open.bmp")
    end
    table.insert(array,"bag/".."t_close.bmp")
    table.insert(array,"bag/".."t_open.bmp")
    local path = table.concat(array,"|")
    local list = self:RepeatFindExS(50,RECT[1],RECT[2],RECT[3],RECT[4], path, "020202", 1.0, 0)
    if #list <= 0 then
        game.log.error("打开物品栏失败")
    end
    
    self.__list = list
    self:Select(id)
end

function BagManager:Select(id)
    local key = id.."_"
    local obj
    for i,conf in ipairs(self.__list) do
        if string.find(conf.name,key) then
            obj = conf
        end
    end
    if not obj then
        game.log.error("错误 没有找到对应的物品栏ID")
    end
    
    if not string.find(obj.name,"_close") then
        game.log.info("当前已经在"..id.."物品栏了")
        return true
    end
    obj.x = obj.x + math.random(5,10)
    obj.y = obj.y + math.random(5,10)
    HardWareUtil:MoveAndClick(obj)

    local check = "bag/"..key.."open.bmp"
    return self:RepeatFind(50,RECT[1],RECT[2],RECT[3],RECT[4], check, "020202", 1.0, 0)
end

function BagManager:CloseBag()
    self.__list = nil
    local path = "bag/t_open.bmp|bag/t_close.bmp"
    local list = self:RepeatFindExS(1,RECT[1],RECT[2],RECT[3],RECT[4], path, "020202", 1.0, 0)
    if #list > 0 then
        --如果物品栏处于打开状态
        HardWareUtil:KeyPad("alt+e")
    end
    skynet.sleep(50)
end

function BagManager:Sort()
    local rect = {225,266,385,330}
    local path = "bag/sort.bmp"
    local pos = self:RepeatFind(10,rect[1],rect[2],rect[3],rect[4], path, "020202", 1.0, 0)
    if not pos then
        game.log.error("排序物品栏失败")
    end
    pos.x = pos.x + math.random(10,20)
    pos.y = pos.y + math.random(4,8)
    HardWareUtil:MoveAndClick(pos)
    path = "bag/sort_all.bmp"
    local pos = self:RepeatFind(10,rect[1],rect[2],rect[3],rect[4], path, "020202", 1.0, 0)
    if not pos then
        game.log.error("排序物品栏失败")
    end
    pos.x = pos.x + math.random(10,20)
    pos.y = pos.y + math.random(4,8)
    HardWareUtil:MoveAndClick(pos)
    skynet.sleep(50)
end

return BagManager