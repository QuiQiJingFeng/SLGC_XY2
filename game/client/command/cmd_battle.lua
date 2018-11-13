local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)

function cmd:Execute(battleType)
    local pos = self:RepeateFind(30000, 730, 400, 800, 470, "in_battle.bmp","000000",1,0)
    if not pos then
        return
    end
    game.log.info("[[进入战斗中]]")
    while true do
        for i=1,1 do
            skynet.sleep(10)
            local pos = self:RepeateFind(1, 730, 400, 800, 470, "in_battle.bmp","000000",1,0)
            
            if not pos then
                game.log.info("[[战斗结束]]")
                return true
            end

            --回合开始
            local pos = self:RepeateFind(1, 676, 200, 767, 440, "huihekaishi.bmp","000000",1,0)
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

cmd["FIGHT"] = function(self)
    HardWareUtil:MoveTo(_p(400+math.random(50),300+math.random(50)))
    HardWareUtil:KeyPad("f1")
    local pos = game.dmcenter:GetCursorPos()
    local rect = _rect(pos,30)
    local path = self:metchResource("jinzhi",".bmp")
    self:RepeateFindEx(10,rect[1],rect[2],rect[3],rect[4],path,"000000",1,0)

    --获取颜色块
    local pos = game.dmcenter:FindColorBlock(0, 75, 339, 460, "004b00-101010|007b00-101010", 1, 50, 30, 20)
    if pos.x == 0 and pos.y == 0 then
        game.log.error("没有找到颜色块")
    end

    local x1 = pos.x - 20
    local y1 = pos.y - 100
    local x2 = pos.x + 80
    local y2 = pos.y
    local screenData = game.dmcenter:GetScreenData(x1,y1,x2,y2)
    local list = screenData.list
    --计算这个矩形范围内,颜色发生的点的坐标
    for i=1,5 do
        local tool = game.dmcenter:GetScreenData(x1,y1,x2,y2)
        local time1 = skynet.time()
        local total = 0
        for index,obj in ipairs(list) do
            obj.num = obj.num or 0
            local nobj = tool:get(index)
            local newcolor = nobj.color
            local numcolor = tonumber("0x"..newcolor)
            if newcolor ~= obj.color then
                if numcolor > tonumber(0x4e5143) and  numcolor < tonumber(0x4e5143) +151515 then
                elseif numcolor > tonumber(0x6c6c62) and  numcolor < tonumber(0x6c6c62) +101010 then
                else
                    
                    obj.corlor = newcolor
                    obj.num = obj.num + 1
                end 
            else
                total = total + 1
            end
        end
        skynet.sleep(1)
    end
    local newlist = {}
    local time1 = skynet.time()
    --将颜色一直不变的干掉 
    local averagePos = _p(0,0)
    for i=#list,1,-1 do
        if list[i].num <= 0 then
            -- table.remove(list,i)
        else
            table.insert(newlist,list[i])
            --计算平均值
            averagePos.x = averagePos.x + list[i].x
            averagePos.y = averagePos.y + list[i].y
        end
    end
    list = newlist
    averagePos.x = averagePos.x / #list
    averagePos.y = averagePos.y / #list

    table.sort(list,function(a,b) 
           local a_waite = _distance(a,averagePos) * a.num
           local b_waite = _distance(b,averagePos) * b.num
        return a_waite < b_waite
    end)

    if #list <= 0 then
        game.log.error("剩余数量点为0")
    end
    local find = false
    for i=1,10 do
        local pos = list[i]
        if i >= 2 then
            pos = list[math.random(i,math.floor(#list/i))] 
        end
        local rect = _rect(pos,50)
        HardWareUtil:MoveAndClick(pos)
        local path1 = self:metchResource("fashu",".bmp")
        local path2 = self:metchResource("jinzhi",".bmp")
        local path = path1.."|"..path2
        local result = self:RepeateFindEx(10,rect[1],rect[2],rect[3],rect[4],path,"000000",1,0,1)
        if not result then
            find = true
            local pos = self:RepeateFind(10, 700, 300, 800, 350, "baohu.bmp","000000",1,0)
            if pos then
                HardWareUtil:KeyPad("alt+a")
            end
            break
        end
    end
    if not find then
        HardWareUtil:DoubleRightClick()
    end
    skynet.sleep(100)
end

cmd["ESCAPE"] = function(self)
    HardWareUtil:MoveTo(_p(400+math.random(50),300+math.random(50)))
    local path = "taopao.bmp"
    local pos = self:RepeateFind(5, 676, 200, 767, 440, path, "020202", 1, 0)
    if not pos then
        game.log.debug("查找逃跑图片失败")
        return
    end
    --点击逃跑按钮
    HardWareUtil:MoveAndClick(pos)
    --召唤兽进行攻击
    HardWareUtil:KeyPad("alt+a")
end

cmd["CATCH"] = function(self)
    local path1 = self:metchResource("master/youling",".bmp")
    local path2 = self:metchResource("master/yegui",".bmp")
    local path = path1.."|"..path2
    local find = nil
    local list = self:RepeateFindEx(100, 0, 75, 339, 460, path,"020202",0.95,0,1)
    if list and #list > 0 then
        find = list[1]
    end

    if not find then
        game.log.debug("没有找到要捕捉的怪物,逃跑中...")
        return self["ESCAPE"](self)
    end
    local master_pos = find
    local path = "buzhuo.bmp"
    local pos = self:RepeateFind(5, 676, 200, 767, 440, path, "020202", 1, 0)
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