local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)

function cmd:Execute(battleType)
    local pos = self:RepeatFind(30, 730, 400, 800, 470, "in_battle.bmp")
    if not pos then
        return
    end
    game.log.info("[[进入战斗中]]")
    while true do
        for i=1,1 do
            skynet.sleep(10)
            local pos = self:RepeatFind(1, 730, 400, 800, 470, "in_battle.bmp")
            if not pos then
                game.log.info("[[战斗结束]]")
                return true
            end

            --回合开始
            local pos = self:RepeatFind(1, 676, 200, 767, 440, "huihekaishi.bmp")
            if not pos then
                break
            end
            game.log.info("回合开始")
            local func = self[battleType]
            if not func then
                game.log.info("[[战斗参数错误]]")
                return
            end
            func(self)
        end
    end
end

function cmd:GetFashuPath()
    local paths = {
        "fashu/1.bmp",
        "fashu/2.bmp",
        "fashu/3.bmp",
        "fashu/4.bmp",
        "fashu/5.bmp",
        "fashu/6.bmp",
        "fashu/7.bmp",
        "fashu/8.bmp",
        "fashu/9.bmp",
        "fashu/10.bmp",
        "fashu/11.bmp",
        "fashu/12.bmp"
    }
    return table.concat(paths, "|")
end

cmd["FIGHT"] = function(self)
    HardWareUtil:KeyPad("f1")
    skynet.sleep(50)
    --获取颜色块
    local pos = game.dmcenter:FindColorBlock(0, 75, 339, 460, "004b00-101010|007b00-101010", 1, 50, 30, 20)
    if pos.x == 0 and pos.y == 0 then
        game.log.error("没有找到颜色块")
    end
    local x1 = pos.x - 20
    local y1 = pos.y
    --计算这个矩形范围内,颜色发生变化最多的点的坐标
    local list = {}
    for i=1,10 do
        for j=1,10 do
            local obj = {}
            obj.x = x1 + (j -1) * 10
            obj.y = y1 - (i -1) * 10
            obj.corlor = ""
            obj.num = -1
            table.insert(list,obj)
        end
    end
    for i=1,10 do
        for i,obj in ipairs(list) do
            local corlor = game.dmcenter:GetColor(obj.x,obj.y)
            local numcolor = tonumber("0x"..corlor)
            if corlor ~= obj.corlor then
                if numcolor > tonumber(0x4e5143) and  numcolor < tonumber(0x4e5143) +151515 then
                else
                    obj.corlor = corlor
                    obj.num = obj.num + 1
                end
               
            end
        end
        skynet.sleep(1)
    end
    skynet.error("总共颜色数量==>",#list)
    --将颜色一直不变的干掉 
    local averagePos = _p(0,0)
    for i=#list,1,-1 do
        if list[i].num <= 0 then
            table.remove(list,i)
        else
            --计算平均值
            averagePos.x = averagePos.x + list[i].x
            averagePos.y = averagePos.y + list[i].y
        end
    end
    averagePos.x = averagePos.x / #list
    averagePos.y = averagePos.y / #list

    table.sort(list,function(a,b) 
        return _distance(a,averagePos) < _distance(b,averagePos)
    end)
    if #list <= 0 then
        game.log.error("剩余数量点为0")
    end
    local pos = list[1]
    for i=1,5 do
        HardWareUtil:MoveAndClick(pos)
    end
    
    skynet.sleep(100)
end

cmd["ESCAPE"] = function(self)
    local path = "taopao.bmp"
    local pos = self:RepeatFind(5, 676, 200, 767, 440, path, "020202", 1, 0)
    if not pos then
        game.log.debug("查找逃跑图片失败")
        return
    end
    --点击逃跑按钮
    HardWareUtil:MoveAndClick(pos)
    --召唤兽进行攻击
    HardWareUtil:KeyPad("alt+a")
    HardWareUtil:MoveTo(_p(400, 300))
end

function cmd:GetCatchPath()
    local paths = {
        "master/yegui/1.bmp",
        "master/yegui/2.bmp",
        "master/yegui/3.bmp",
        "master/yegui/4.bmp",
        "master/yegui/5.bmp",
        "master/yegui/6.bmp",
        "master/yegui/7.bmp",
        "master/yegui/8.bmp",
        "master/youling/1.bmp",
        "master/youling/2.bmp",
        "master/youling/3.bmp",
        "master/youling/4.bmp",
        "master/youling/5.bmp",
        "master/youling/6.bmp",
        "master/youling/7.bmp",
        "master/youling/8.bmp",
        "master/youling/9.bmp",
        "master/youling/10.bmp",
        "master/youling/11.bmp",
        "master/youling/12.bmp"
    }
    return table.concat(paths, "|")
end

cmd["CATCH"] = function(self)
    local path = self:GetCatchPath()
    local find = nil
    for i=1,100 do
        local list = self:RepeatFindEx(1, 0, 75, 339, 460, path,"020202",0.95)
        if #list > 0 then
            find = list[1]
        end
        skynet.sleep(1)
    end

    if not find then
        game.log.debug("没有找到要捕捉的怪物,逃跑中...")
        return self["ESCAPE"](self)
    end
    local master_pos = find
    local path = "buzhuo.bmp"
    local pos = self:RepeatFind(5, 676, 200, 767, 440, path, "020202", 1, 0)
    if not pos then
        game.log.debug("查找捕捉按钮失败")
        return
    end
    --点击捕捉按钮
    HardWareUtil:MoveAndClick(pos)
    skynet.sleep(50)
    --移动到怪物的头上并点击
    HardWareUtil:MoveAndClick(master_pos)
    skynet.sleep(50)
    --召唤兽进行防御
    HardWareUtil:KeyPad("alt+d")
    HardWareUtil:MoveTo(_p(400, 300))
end


return cmd