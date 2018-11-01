local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local cmd_base = class("cmd_base")

--检测小地图是否为打开状态
--num 需要检测的次数 默认3次 耗时0-0.3s
--最坏的情况下,小地图没有打开,则耗时0.3s
function cmd_base:IsSmallMapOpen(num)
    num = num or 1
    local smallOpen = self:RepeatFind(num, 0, 0, 800, 600, "2.bmp", "020202", 1, 0)
    return smallOpen and true or false
end
--检测大地图是否为打开状态
--num 需要检测的次数 默认3次 耗时0-0.3s
--最坏的情况下,大地图没有打开,则耗时0.3s
function cmd_base:IsBigMapOpen(num)
    num = num or 1
    local bigOpen = self:RepeatFind(num, 80, 500, 130, 530, "1.bmp", "020202", 1, 0)
    return bigOpen and true or false
end


function cmd_base:GetCurAreaAndPos()
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
    return
end

function cmd_base:Capture(x1,y1,x2,y2)
    local time = skynet.time()
	local path = "error/".. os.date("%Y-%m-%d_%H-%M-%S",time) .. ".bmp"
    local success = game.dmcenter:Capture(x1,y1,x2,y2, path)
	if success then
        return path
    end
    game.log.warning("截图失败")
end

function cmd_base:GetCurAreaAndPosWithCapther()
    local data = self:GetCurAreaAndPos()
    if not data then
        local path = self:Capture(0, 0, 150, 30)
        game.log.warning("获取当前场景的名称、坐标失败,截图存放在[%s]",path)
    end
    return data
end

--获取当前的飞行状态
function cmd_base:GetCurFlyState()
    --打开飞行御器 界面
    HardWareUtil:KeyPad("alt+u")

    local path = "13.bmp|14.bmp"
    local array = self:RepeatFindEx(10, 100, 100, 800, 600, path, "020202", 1, 0)
    if #array <= 0 then
        game.log.warning("飞行状态查询失败")
        return
    end
    local fly = false
    local index = array[1].index
    if index == 0 then
        fly = false
    elseif index == 1 then
        fly = true
    end
    HardWareUtil:KeyPad("alt+u")
    
    return fly
end

function cmd_base:FlyDown()
    if self:GetCurFlyState() then
        HardWareUtil:KeyPad("alt+c")
        skynet.sleep(50)
    end
end

function cmd_base:FlyUp()
    if not self:GetCurFlyState() then
        HardWareUtil:KeyPad("alt+c")
        skynet.sleep(50)
    end
end

function cmd_base:RepeatFind(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
    local pos = nil
    num = num or 1
    for idx = 1, num do
        pos = game.dmcenter:FindPic(x1, y1, x2, y2, pic_name, delta_color, sim, dir)
        if pos.x ~= 0 or pos.y ~= 0 then
            break
        end
        if num ~= idx then
            skynet.sleep(10)
        end
    end
    return (pos.x ~= 0 or pos.y ~= 0) and pos or nil
end

function cmd_base:RepeatFindEx(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
    local ret = ""
    num = num or 1
    for idx = 1, num do
        ret = game.dmcenter:FindPicEx(x1, y1, x2, y2, pic_name, delta_color, sim, dir)
        if ret ~= "" then
            break
        end
        if num ~= idx then
            skynet.sleep(10)
        end
    end
    if ret == "" then
        return {}
    end
    local array = {}
    local list = string.split(ret, "|")
    for _, conf in ipairs(list) do
        local temp = string.split(conf, ",")
        local data = {index = tonumber(temp[1]), x = tonumber(temp[2]), y = tonumber(temp[3])}
        table.insert(array, data)
    end

    return array
end

function cmd_base:RepeatFindNotPicX(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir, callback)
    local has = false
    for i = 1, num do
        local list = self:RepeatFindEx(1, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
        if #list <= 0 then
            return true
        else
            callback()
        end
    end
end

-- 获取小地图上的点的坐标在屏幕上的位置
function cmd_base:ConvertToWordSpace(name, pos, source)
    local data = game.data:GetSmallMapByName(name)
    local path = "6.bmp|7.bmp"
    local list = self:RepeatFindEx(10,0,0,2000,2000, path, "020202", 1, 0)
    if #list <= 1 then
        game.log.warning("没有找到小地图边界,无法进行坐标到像素的转换 length="..#list)
        return
    end
    --大地图打开像大雁塔那样的场景时需要特殊处理
    --但是小地图打开不需要特殊处理
    if source == "big" and data.dx1 > 0 then
        local temp = _clone(list[1])
        list[1].x = temp.x + data.dx1
        list[1].y = temp.y - data.dy1
        list[2].x = temp.x + data.dw + data.dx1
        list[2].y = temp.y - (data.dh + data.dy1)
    end

    local width = math.abs(list[2].x - list[1].x)
    local height = math.abs(list[2].y - list[1].y)
    --小地图的实际像素范围
    local pixelRect = _rect(list[1].x, list[1].y, width, height)
    --小地图的坐标范围
    local coordRect = _rect(data.x, data.y, data.width, data.height)
    local xradio = pixelRect.width / coordRect.width
    local yradio = pixelRect.height / coordRect.height

    local size = game.dmcenter:GetClientSize()
    local x = math.ceil(list[1].x + pos.x * xradio)
    local y = list[1].y - pos.y * yradio
    return _p(x, y)
end

return cmd_base