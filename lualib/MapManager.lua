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
    local path = self:Capture(0, 0, 150, 30)
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
    self:OpenSmallMapFromBigMap(data.name)
    local pixelPos =  game.map:ConvertToWordSpace(data.name, data, true)
    HardWareUtil:MoveAndClick(pixelPos)
    skynet.sleep(50)
    self:CloseAllMap()
end


return MapManager