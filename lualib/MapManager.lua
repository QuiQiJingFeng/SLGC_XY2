local HardWareUtil = require "HardWareUtil"
local skynet = require "skynet"
local super = require "command.cmd_base"
local MapManager = class("MapManager", super)

--检查大地图是否打开
function MapManager:CheckBigMapOpen(num)
    num = num or 1
    local bigOpen = self:RepeateFind(num, 80, 500, 130, 530, "1.bmp", "020202", 1, 0)
    return bigOpen and true or false
end
--检查小地图是否打开
function MapManager:CheckSmallMapOpen(num)
    num = num or 1
    local smallOpen = self:RepeateFind(num, 0, 0, 800, 600, "2.bmp", "020202", 1, 0)
    return smallOpen and true or false
end

--打开大地图
function MapManager:OpenBigMap()
    game.log.info("打开大地图")
	HardWareUtil:KeyPad("alt+2")
	return self:CheckBigMapOpen(10)
end

--打开当前场景的小地图
function MapManager:OpenCurSmallMap()
    game.log.info("打开当前小地图")
    HardWareUtil:KeyPad("alt+1")
	return self:CheckSmallMapOpen(10) and true or false
end

--关闭大地图和小地图
function MapManager:CloseAllMap()
    game.log.info("关闭所有地图")
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
    if not self:CheckSmallMapOpen(10) then
        game.log.error("没有检测到小地图打开")
    end
end

-- 获取小地图上的点的坐标在屏幕上的位置
function MapManager:ConvertToWordSpace(name, pos, fromBigMap)
    local data = game.data:GetSmallMapByName(name)
    local path = "6.bmp|7.bmp"
    local list = self:RepeateFindEx(10,0,0,800,600, path, "020202", 1, 0)
    if not list or #list <= 1 then
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
    local data = self:GetCurAreaAndPos(true)
    local pixelPos = self:ConvertToWordSpace(data.name,pos)
    HardWareUtil:MoveAndClick(pixelPos)
    skynet.sleep(50)
    self:CloseAllMap()
end
function MapManager:OpenBigMapToSmallAndClick(name,pos)
    self:CloseAllMap()
    self:OpenBigMap()
    self:OpenSmallMapFromBigMap(name)
    local pixelPos =  self:ConvertToWordSpace(name, pos, true)
    HardWareUtil:MoveAndClick(pixelPos)
    skynet.sleep(50)
    self:CloseAllMap()
end

--检查是否可以飞行
--name 目标场景名称
--coordPos 目标坐标
--@return 目标位置是否有飞行棋
function MapManager:TestFlyByFlag(name, coordPos,fromBigMap)
    local data = self:GetCurAreaAndPos(true)
    local pixelPos = self:ConvertToWordSpace(name, coordPos,fromBigMap)
    local playerPixelPos = self:ConvertToWordSpace(name, _p(data.x, data.y),fromBigMap)

    HardWareUtil:MoveTo(_p(math.random(750,800),math.random(0,50)))
    skynet.sleep(50)

    --只检查蓝色飞行棋
    local list = self:RepeateFindEx(5, 0, 0, 800, 600, "11.bmp", "020202", 1.0, 0)
    if #list <= 0 then
        game.log.info("没有飞行棋")
        return
    end
    --为了避免两个旗距离相等,加个0-1的随机数
    for _, pos in ipairs(list) do
        pos.wight = _distance(pos, pixelPos) + math.random(0,1)
    end
    --将飞行棋按照距离目标点的距离远近进行排序
    table.sort(list,function(a, b)
            return a.wight < b.wight
        end)
    
    --飞行之前 先要 降落下来
    self:FlyDown()
    --取一个距离目标点最近的旗
    local flag = list[1]
    local playerDistance = _distance(playerPixelPos, pixelPos)
    --旗子跟目标点的距离
    local flagDistance = flag.wight
    local canfly = false
    if name ~= data.name then
        canfly = true
    else
        local delt = 100
        --如果人物跟目标点的距离 比 旗子到目标点的距离只多100 像素的话不值得飞的
        --如果飞行棋距离目标点过近，会导致点到飞行棋上,而大于50像素的话是不会将目标点盖住的
        if playerDistance - flagDistance > delt  or flagDistance <= 50 then
            canfly = true
        end
    end

    if canfly then
        HardWareUtil:MoveAndClick(flag)
        HardWareUtil:MoveTo(_p(700,50))
        local obj = self:RepeateSearchWords(10,"ST_11","送我去",96, 127, 587+96, 362+127,"00d011-101010",1)
        if not obj then
            game.log.error("没有找到[送我去]文字")
        end
        HardWareUtil:MoveAndClick(obj)
        skynet.sleep(100)
    end
    game.log.infof("距离为:%d",flagDistance)
    return flagDistance <= 30
end

function MapManager:CheckExit(tname,tpos,stopArea)
    local nextLoop = true
    local data = self:GetCurAreaAndPos(true)
    self.__inArea = tname == data.name
    if self.__inArea and _distance(data,tpos) < 10 then
        nextLoop = false
    elseif self.__inArea and stopArea then
        nextLoop = false
    end
    return nextLoop
end

function MapManager:GoTo(tname,tpos,stopArea,makeFlag)
    game.log.infof("寻路开始 [%s]=>[%d,%d]",tname,tpos.x,tpos.y)
    self:WaitMoveEnd()
    self:CheckExit(tname,tpos,stopArea)
    if makeFlag then
        local fromBigMap = true
        if self.__inArea then
            fromBigMap = false
            self:OpenCurSmallMap()
        else
            self:CloseAllMap()
            self:OpenBigMap()
            self:OpenSmallMapFromBigMap(tname)
        end
        --寻路开始之前先检查一下能不能直接飞过去
        makeFlag = makeFlag and not self:TestFlyByFlag(tname, tpos,fromBigMap)
        
    end

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
    if makeFlag then
        game.log.info("插旗")
        return self:MakeFlag()
    end
    return true
end


function MapManager:ClilckFlag(pos)
    HardWareUtil:MoveAndClick(pos)
    local obj = self:RepeateSearchWords(10,"ST_11","送我去",96, 127, 587+96, 362+127,"00d011-101010",1)
    if not obj then
        game.log.error("没有找到送我去的提示")
    end
    HardWareUtil:MoveAndClick(obj)
    skynet.sleep(50)
    return true
end
--小红点查找NPC
function MapManager:SearchByRedPoint(npcName)
    self:CloseAllMap()
    self:OpenCurSmallMap()
	HardWareUtil:SendGBKString(npcName)
    local pos = self:RepeateFind(10,100,100,800,600,"3.bmp","020202",1,0)
    if not pos then
        game.log.error("没有找到该NPC选项")
    end
    pos.x = pos.x - math.random(50,80)
    pos.y = pos.y + 30
    HardWareUtil:MoveAndClick(pos)
    skynet.sleep(50)

    local path = "4.bmp|5.bmp"
    local array = self:RepeateFindEx(5,100,100,800,600, path, "020202",1,0)
    if not array or #array <= 0 then
        game.log.error("小红点被挡住了")
    end

    local pos = array[1]
    HardWareUtil:MoveAndClick(pos)
    return self:WaitMoveEnd()
end

local CONVERT_NAMES = {
    ["金銮殿"] = { name = "皇宫",x=139,y=59},
    ["药店"] = {name = "洛阳城",x=163,y=164},
    ["杂货店"] = {name = "长安城",x=90,y=155},
    ["狮子洞"] = {name = "狮驼岭",x=40,y=30}
}
function MapManager:GoRoomScene(sceneName,npcName)
    local data = CONVERT_NAMES[sceneName]
    if not data then
        game.log.error("没有指定的转换配置")
    end
    self:CloseAllMap()
    self:OpenBigMap()
    self:OpenSmallMapFromBigMap(data.name)
    local pixelPos =  self:ConvertToWordSpace(data.name, data, true)
    --将鼠标移动到不覆盖旗帜的位置
    HardWareUtil:MoveTo(_p(pixelPos.x+math.random(30,50),pixelPos.y+math.random(30,50)))
    
    local path = "12.bmp"
    local rect = _rect(pixelPos,30)
    local list = self:RepeateFindEx(5,rect[1],rect[2],rect[3],rect[4], path, "020202", 1.0, 0)
    if list and #list > 0 then
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
    HardWareUtil:MoveTo(_p(700,400))
    skynet.sleep(50)
    --打开任务栏1
    game.bag:OpenBag(1)
    local CONTENT_RECT = {25,290,345,510}
    --获取获取所有的孔明灯 以及详细信息
    local list = game.item:Distinguish("孔明灯",CONTENT_RECT)
    list = game.item:GetKongMingDengDetail(list)
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
        game.log.info("插旗完成")
        game.bag:CloseBag()
        return true
    end
    local obj = self:RepeateSearchWords(10,"ST_11","新增路标",96, 127, 587+96, 362+127,"00d011-101010",1)
    if not obj then
        game.log.error("没有找到 新增路标")
    end
    HardWareUtil:MoveAndClick(obj)
    skynet.sleep(50)
    game.log.info("插旗完成")
    game.bag:CloseBag()
    return true
end

--获取当前角色的实际屏幕坐标 --1个坐标==20 像素
function MapManager:getPlayerPixelPos()
    local size = game.dmcenter:GetClientSize()
    local center = _p(math.ceil(size.width / 2), math.ceil(size.height / 2))
    local data = self:GetCurAreaAndPos(true)
    local conf = game.data:GetSmallMapByName(data.name)
    local unit = 20
    local mapSize = _size(conf.width * unit, conf.height * unit)
    local x, y
    local curRealPos = _p(data.x * unit, data.y * unit)
    if curRealPos.x >= size.width / 2 and curRealPos.x <= mapSize.width - (size.width / 2) then
        x = center.x
    end
    if curRealPos.y >= size.height / 2 and curRealPos.y <= mapSize.height - (size.height / 2) then
        y = center.y
    end

    if curRealPos.x < size.width / 2 then
        x = curRealPos.x
    end
    if curRealPos.x > mapSize.width - (size.width / 2) then
        x = size.width - (mapSize.width - curRealPos.x)
    end

    if curRealPos.y < size.height / 2 then
        y = size.height - curRealPos.y
    end

    if curRealPos.y > mapSize.height - (size.height / 2) then
        y = size.height - size.height / 2 - (mapSize.height - curRealPos.y) + center.y
    end
    return _p(x, y)
end

--查找对话标志,旁边才能使用
function MapManager:ChatPos(coordPos,type)
	local data = self:GetCurAreaAndPos(true)
	local dx = (coordPos.x - data.x) * 20
	local dy = (data.y - coordPos.y) * 20
	local playerPixelPos = self:getPlayerPixelPos()
	if not playerPixelPos then
		return game.log.error("获取玩家像素位置失败")
	end
	local x = playerPixelPos.x + dx
	local y = playerPixelPos.y + dy

	local targetCPos = _p(x,y)

	local findChat = false
	local unit = 10
    for i=1,10 do
        local px = math.random(0,1) > 0.5 and 1 or -1
        local dx = math.random(5,10) * px
		HardWareUtil:MoveTo(_p(targetCPos.x+dx,targetCPos.y))
		skynet.sleep(20)
		if type == "finger" then
	    	local path = "finger_1.bmp"
	    	local pos = game.dmcenter:FindPic(0,0,800,600,path,"020202",1,0.8)
	      	if pos.x ~= 0 or pos.y ~= 0 then
	      		findChat = true
	      		break
	      	end
	    else
	    	local path = "chat_1.bmp|chat_2.bmp|chat_3.bmp|chat_4.bmp"
		    local ret = game.dmcenter:FindPicExS(0,0,800,600, path, "020202", 1, 0)
		    if not (ret == "") then
                findChat = true
                targetCPos.x = targetCPos.x + dx
		    	break
		    end
	    end
	   	targetCPos.y = targetCPos.y - unit
	end
    if not findChat then
        game.log.error("没有找到对话图标")
		return
	end
    HardWareUtil:MoveAndClick(targetCPos)
    skynet.sleep(50)
	return true
end

function MapManager:FlyDown()
	if self:GetCurFlyState() then
		HardWareUtil:KeyPad("alt+c")
		skynet.sleep(50)
	end
end

function MapManager:FlyUp()
	if not self:GetCurFlyState() then
		HardWareUtil:KeyPad("alt+c")
		skynet.sleep(50)
	end
end

function MapManager:GetCurFlyState()
	--打开飞行御器 界面
 	HardWareUtil:KeyPad("alt+u")
 	
    local path = "13.bmp|14.bmp"
    local array = self:RepeateFindEx(10,100,100,800,600, path, "020202", 1, 0)
    if not array then
        game.log.info("飞行状态查询失败")
        return
    end
 	local fly = false
   	local index = array[1].index
   	if index == 0 then
   		fly = false
   	elseif index == 1 then
   		fly = true
   	else
   		game.log.error("FLY STATE ERROR res = ",res)
   	end
	HardWareUtil:KeyPad("alt+u")

	return fly
end

return MapManager