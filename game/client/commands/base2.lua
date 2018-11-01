local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local cmd_base = {}
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
    
    local config = game.data:GetSmallMapByName(name)
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

function cmd_base:GetCurAreaAndPos(ignoreError)
    if not game.dmcenter:UseDict(0) then
        game.log.warning("切换字典失败")
        return
    end
    local text = game.dmcenter:Ocr(0,0,150,30,"ffffff-000000",1)
    local iter = string.gmatch(text,"%d+")
    local x = iter()
    local y = iter()
    if not x or not y then
        game.log.info("获取当前地区名称和坐标失败")
        if ignoreError then
            return
        end
        if game.cmdcenter:TestExecute("1107","taopao") then
            return self:GetCurAreaAndPos()
        end
        return
    end
    x = tonumber(x)
    y = tonumber(y)
    local name = string.gsub(text,"%b[]","")
    name = string.gsub(name,"大雁塔顶","大雁塔七层")
    return {name=name,x=x,y=y}
end

local FORBID_FLY_FLAG = false
--禁止使用飞行棋<地府任务特殊需要>
function cmd_base:SetForbidFlyFlag(flag)
    FORBID_FLY_FLAG = flag
end

--检查是否可以飞行
--name 目标场景名称
--coordPos 目标坐标
function cmd_base:CheckFlyFlag(name, coordPos,source,yellow,conf)
    if FORBID_FLY_FLAG then
        game.log.info("当前禁止飞行棋飞行")
        return
    end
    local data = self:GetCurAreaAndPos()
    if not data then
        game.log.warning("获取当前场景名称、坐标失败")
        return
    end

    local pixelPos = self:ConvertToWordSpace(name, coordPos,source)
    if not pixelPos then
        game.log.warningf("转换坐标到屏幕坐标失败 地区[%s]", name)
        return
    end

    HardWareUtil:MoveTo(0,0)
    skynet.sleep(10)

    local playerPixelPos = self:ConvertToWordSpace(name, _p(data.x, data.y),source)
    local path = "11.bmp" --去掉黄色的飞行棋 12.bmp
    --为了直接飞到屋里做的判断
    if yellow then
        path = "12.bmp"
    end
    local x1 = 0
    local y1 = 0
    local x2 = 800
    local y2 = 600
    if conf then
        x1 = conf.x1
        y1 = conf.y1
        x2 = conf.x2
        y2 = conf.y2
    end
    local list = self:RepeatFindEx(5, x1, y1, x2, y2, path, "020202", 1.0, 0)
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
    local delt = 100
    --如果人物跟目标点的距离 减去 旗子跟目标点的距离 大于delt个 像素,就不飞行了
    local playerDistance = _distance(playerPixelPos, pixelPos)
    local flagDistance = flag.wight

    local canfly = false
    if name ~= data.name then
        canfly = true
    else
        --如果飞行棋距离目标点过近，会导致点到飞行棋上,而大于50像素的话
        --是不会将目标点盖住的
        if playerDistance - flagDistance > delt  or flagDistance <= 50 then
            canfly = true
        end
    end
    if canfly then
        HardWareUtil:MoveAndClick(list[1])
        for i=1,1000 do
            local success = self:searchAndClickText("00d011-101010", "送我去")
            if success then
                return true
            end
            skynet.sleep(10)
        end
        skynet.sleep(100)
    end
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

function cmd_base:searchAndClickText(corlor_format, text)
    if not game.dmcenter:UseDict(1) then
        game.log.warning("字库切换失败")
        return
    end
    local list = game.dmcenter:GetWordsNew(100, 125, 650, 500, corlor_format, 1)
    if not list or #list <= 0 then
        return
    end
    local select = nil
    for _, obj in pairs(list) do
        if string.find(obj.word, text) then
            select = obj
        end
    end
    if not select then
        return
    end
    HardWareUtil:MoveAndClick(select.pos)
    skynet.sleep(100)

    return true
end

function cmd_base:FlyDown()
    if self:GetCurFlyState() then
        HardWareUtil:KeyPad("alt+c")
        skynet.sleep(50)
    end
end

--获取当前角色的实际屏幕坐标 --1个坐标==20 像素
function cmd_base:getPlayerPixelPos()
    local size = game.dmcenter:GetClientSize()
    local center = _p(math.ceil(size.width / 2), math.ceil(size.height / 2))
    local data = self:GetCurAreaAndPos()
    if not data then
        game.log.warning("获取当前地图和坐标失败")
        return
    end
    local config = game.data.getSmallMap()
    local conf = config[data.name]
    if not conf then
        game.log.warningf("获取小地图数据[%s]失败", data.name)
        return
    end

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

--解析当前任务栏任务，并返回其描述
function cmd_base:parseTask(taskName, corlor_format)
    --打开任务面板
    game.cmdcenter:Execute("1007")
    if not game.dmcenter:UseDict(1) then
        game.log.error("切换字库失败")
        return
    end
    local list
    local select = nil
    game.dmcenter:SetWordGap(10)
    for i = 1, 5 do
        list = game.dmcenter:GetWordsNew(149, 160, 149 + 149, 234 + 160, "ffffff-101010|d2d000-303030|989413-303030", 1)
        --检查当前是否有职业任务这个选项
        --如果没有,那么将所有处于打开状态的任务关闭 之后再次检查
        for i, obj in ipairs(list) do
            if string.find(obj.word, taskName) then
                select = obj
                break
            end
        end
        if select then
            break
        end
        --如果所有的都处于关闭状态了还没有找到职业任务
        local hasOpen = false
        for i = #list, 1, -1 do
            local obj = list[i]
            if string.find(obj.word, "★") then
                HardWareUtil:MoveAndClick(obj.pos)
                skynet.sleep(1)
                hasOpen = true
            end
        end
        --没有职业任务
        if not hasOpen then
            --关闭任务面板
            game.cmdcenter:Execute("1008")
            return
        end
        HardWareUtil:MoveTo(0, 0)
        skynet.sleep(10)
    end
    if not select then
        --关闭任务面板
        game.cmdcenter:Execute("1008")
        return
    end

    --如果处于关闭状态,那么打开它
    if string.find(select.word, "☆") then
        HardWareUtil:MoveAndClick(select.pos)
        skynet.sleep(20)
    end
    select.pos.y = select.pos.y + 20
    HardWareUtil:MoveAndClick(select.pos)
    skynet.sleep(20)
    corlor_format = corlor_format or "00ff00-101010"
    local str = game.dmcenter:Ocr(371, 158, 275 + 371, 293 + 158, corlor_format, 1)
    str = game.dmcenter:GBKToUTF8(str)

    --关闭任务面板
    game.cmdcenter:Execute("1008")

    return str
end

function cmd_base:WaitMoveEnd()
    local prePos = _p(0, 0)
    while true do
        local pos = self:GetCurAreaAndPos(true)
        if not pos then
            return
        end
        local dist = _distance(prePos, pos)
        if dist == 0 then
            return true
        end
        prePos = pos
        skynet.sleep(100)
    end
end

function cmd_base:FixName(name)
    local tempName = name
    if string.find(tempName, "大雁塔") then
        tempName = "大雁塔"
    elseif string.find(tempName, "地狱迷宫") then
        tempName = "地狱迷宫"
    elseif string.find(tempName, "龙窟") then
        tempName = "龙窟"
    elseif string.find(tempName, "凤巢") then
        tempName = "凤巢"
    elseif string.find(tempName, "海底迷宫") then
        tempName = "海底迷宫"
    end
    return tempName
end


return cmd_base