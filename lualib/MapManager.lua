local HardWareUtil = require "HardWareUtil"
local skynet = require "skynet"
local super = require "commands.base"
local MapManager = class("MapManager", super)

--检查大地图是否打开
function MapManager:CheckBigMapOpen(num)
    num = num or 1
    local bigOpen = self:RepeatFind(num, 80, 500, 130, 530, "1.bmp", "020202", 1, 0)
    return bigOpen and true or false
end
--检查小地图是否打开
function MapManager:CheckSmallMapOpen(num)
    num = num or 1
    local smallOpen = self:RepeatFind(num, 0, 0, 800, 600, "2.bmp", "020202", 1, 0)
    return smallOpen and true or false
end

--打开大地图
function MapManager:OpenBigMap()
	HardWareUtil:KeyPad("alt+2")
	return self:IsBigMapOpen(10)
end

--打开当前场景的小地图
function MapManager:OpenCurSmallMap()
    HardWareUtil:KeyPad("alt+1")
	return self:CheckSmallMapOpen(10) and true or false
end

--关闭大地图和小地图
function MapManager:CloseAllMap()
    local smallClose = false
	local smallOpen = self:CheckSmallMapOpen()
	if smallOpen then
		HardWareUtil:KeyPad("alt+1")
		smallClose = true
	end

	local bigOpen = self:CheckBigMapOpen()
	if bigOpen then
		HardWareUtil:KeyPad("alt+2")
    end
    skynet.sleep(50)
end

function MapManager:CloseSmallMap()
	local smallOpen = self:CheckSmallMapOpen()
	if smallOpen then
		HardWareUtil:KeyPad("alt+1")
        skynet.sleep(50)
	end
end

function MapManager:CloseBigMap()
    local bigOpen = self:CheckBigMapOpen()
	if bigOpen then
		HardWareUtil:KeyPad("alt+2")
	end
end

--调用之前请确认大地图是打开的
function MapManager:OpenSmallMapFromBigMap(name)
    local data = game.data:GetBigMapByName(name)
    local x = data.x + math.random(0,data.dx)
    local y = data.y + math.random(0,data.dy)
    HardWareUtil:MoveAndClick(_p(x, y))
    --检测小地图是否打开
    if not self:IsSmallMapOpen(10) then
        game.log.error("没有检测到小地图打开")
    end
end

-- 获取小地图上的点的坐标在屏幕上的位置
function MapManager:ConvertToWordSpace(name, pos, fromBigMap)
    local data = game.data:GetSmallMapByName(name)
    local path = "6.bmp|7.bmp"
    local list = self:RepeatFindEx(10,0,0,800,600, path, "020202", 1, 0)
    if #list <= 1 then
        game.log.error("没有找到小地图边界,无法进行坐标到像素的转换 length="..#list)
    end
    --大地图打开像大雁塔那样的场景时需要特殊处理
    --但是小地图打开不需要特殊处理
    if fromBigMap and data.dx1 > 0 then
        local temp = _clone(list[1])
        list[1].x = temp.x + data.dx1
        list[1].y = temp.y - data.dy1
        list[2].x = temp.x + data.dw + data.dx1
        list[2].y = temp.y - (data.dh + data.dy1)
    end

    local width = math.abs(list[2].x - list[1].x)
    local height = math.abs(list[2].y - list[1].y)
    --小地图的实际像素范围
    local pixelRect = {x = list[1].x,y= list[1].y,width= width,height= height}
    --小地图的坐标范围
    local coordRect = {x=data.x, y=data.y, width = data.width,height = data.height}
    local xradio = pixelRect.width / coordRect.width
    local yradio = pixelRect.height / coordRect.height

    local size = game.dmcenter:GetClientSize()
    local x = math.ceil(list[1].x + pos.x * xradio)
    local y = list[1].y - pos.y * yradio
    return _p(x, y)
end

function MapManager:GetCurAreaAndPos(checkError)
    game.dict:ChangeDict("ST_9")
    local text = game.dmcenter:Ocr(0, 0, 150, 30, "ffffff-000000", 1)
    for i=1,1 do
        --加保护监控
        if not string.find(text, "%[") or not string.find(text, "%]") then
            break
        end
        local iter = string.gmatch(text, "%d+")
        local x = iter()
        local y = iter()
        if not x or not y then
            break
        end
        x = tonumber(x)
        y = tonumber(y)
        if not x or not y then
            break
        end
        local name = string.gsub(text, "%b[]", "")
        if name == "" then
            break
        end
        return {name=name,x=x,y=y}
    end
    if checkError then
        game.log.error("获取当前场景的名称、坐标失败")
    end
    return
end

function MapManager:OpenCurSmallAndClick(pos)
    self:CloseAllMap()
    self:OpenCurSmallMap()
    local data = self:GetCurAreaAndPosWithCapther()
    local pixelPos = self:ConvertToWordSpace(data.name,pos)
    HardWareUtil:MoveAndClick(pixelPos)
    skynet.sleep(50)
    self:CloseAllMap()
end
function MapManager:OpenBigMapToSmallAndClick(name,pos)
    self:CloseAllMap()
    self:OpenBigMap()
    self:OpenSmallMapFromBigMap(name)
    local pixelPos =  game.map:ConvertToWordSpace(name, pos, true)
    HardWareUtil:MoveAndClick(pixelPos)
    skynet.sleep(50)
    self:CloseAllMap()
end

function MapManager:CheckExit(tname,tpos,stopArea)
    local nextLoop = true
    local data = self:GetCurAreaAndPosWithCapther()
    self.__inArea = tname == data.name
    skynet.error(self.__inArea,"FYD---",tname,data.name)
    if tname == data.name and _distance(data,tpos) < 10 then
        nextLoop = false
    elseif tname == data.name and stopArea then
        nextLoop = false
    end
    return nextLoop
end

function MapManager:GoTo(tname,tpos,stopArea)
    game.log.infof("寻路开始 [%s]=>[%d,%d]",tname,tpos.x,tpos.y)
    self:WaitMoveEnd()
    local times = 0
    while self:CheckExit(tname,tpos,stopArea) do
        for i=1,1 do
            if self.__inArea then
                times = times + 1
                if times >= 2 then
                    self:FlyUp()
                end
                self:OpenCurSmallAndClick(tpos)
            else
                HardWareUtil:MoveTo(_p(400,300))
                skynet.sleep(30)
                if game.tip:CheckYellowArea() then
                    break
                end
                self:OpenBigMapToSmallAndClick(tname,tpos)
            end
            self:WaitMoveEnd()
        end
    end
    self:FlyDown()
    game.log.info("寻路结束")
end


function MapManager:ClilckFlag(pos)
    HardWareUtil:MoveAndClick(pos)
    local success = false
    for i=1,20 do
        success = self:searchAndClickText("00d011-101010", "送我去")
        if success then
            break
        end
        skynet.sleep(10)
    end
    if not success then
        game.log.error("没有找到送我去的提示")
    end
    return true
end

function MapManager:SearchByRedPoint(npcName)
    game.map:CloseAllMap()
    self:OpenCurSmallMap()
    HardWareUtil:SendGBKString(npcName)
    local pos = self:RepeatFind(10,0,0,800,600,"3.bmp","020202",1,0)
    if not pos then
        game.log.error("没有找到该NPC选项")
    end

    pos.x = pos.x - math.random(50,80)
    pos.y = pos.y + 30
    HardWareUtil:MoveAndClick(pos)
    
    local path = "4.bmp|5.bmp"
    local array = self:RepeatFindEx(10,100,100,800,600, path, "020202",1,0)
    if #array <= 0 then
        game.log.error("小红点被挡住了")
    end

    local pos = array[1]
    HardWareUtil:MoveAndClick(pos)
    --关闭自己打开的地图
    game.map:CloseAllMap()
    return self:WaitMoveEnd()
end

local CONVERT_NAMES = {
    ["金銮殿"] = { name = "皇宫",x=139,y=59},
    ["药店"] = {name = "洛阳城",x=163,y=164},
    ["杂货店"] = {name = "长安城",x=90,y=155}
}
function MapManager:GoRoomScene(sceneName,npcName)
    local data = CONVERT_NAMES[sceneName]
    if not data then
        game.log.error("没有指定的转换配置")
    end
    game.map:CloseAllMap()
    game.map:OpenBigMap()
    game.map:OpenSmallMapFromBigMap(data.name)
    local pixelPos =  game.map:ConvertToWordSpace(data.name, data, true)
    --将鼠标移动到不覆盖旗帜的位置
    HardWareUtil:MoveTo(_p(pixelPos.x+math.random(30,50),pixelPos.y+math.random(30,50)))
    
    local path = "12.bmp"
    local rect = _rect(pixelPos,30)
    local list = self:RepeatFindEx(5,rect[1],rect[2],rect[3],rect[4], path, "020202", 1.0, 0)
    local markFlag = false
    if #list > 0 then
        game.log.info("找到黄色飞行棋,直接飞过去")
        return self:ClilckFlag(list[1])
    end
    game.log.info("没有找到飞行棋,自己寻路过去")
    --如果没有黄色飞行棋,那么寻路过去
    self:GoTo(data.name,_p(math.random(20,40),math.random(20,40)),true)
    game.log.infof("到达当前场景,使用小红点的方式查找NPC[%s]",npcName)
    --小红点找到对应的NPC
    self:SearchByRedPoint(npcName)
    game.log.info("到达NPC地点,做个77")
    --之后设置个旗
    return self:MakeFlag()
end

function MapManager:MakeFlag()
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

return MapManager