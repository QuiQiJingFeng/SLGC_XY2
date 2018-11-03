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

function cmd:SearchMaster(pos)
    pos.y = pos.y - 10
    local find = false
    for i=1,8 do
        HardWareUtil:MoveTo(pos)
        local path = self:GetFashuPath()
        local unit = 50
        local x1 = pos.x - 50
        local y1 = pos.y - 50
        local x2 = pos.x + 50
        local y2 = pos.y + 50
        local times = 0
        for i=1,2 do
            local list = self:RepeatFindEx(1, x1, y1, x2, y2, path)
            if #list > 0 then
                times = times + 1
                if times >= 2 then
                    find = true
                    break
                end
                skynet.sleep(5)
            end
        end
        if find then
            break
        end
        pos.y = pos.y - 10
    end
    if not find then
        return
    end
    return pos
end

cmd["FIGHT"] = function(self)
    HardWareUtil:KeyPad("f1")
    skynet.sleep(50)
    local pos = game.dmcenter:FindColorBlock(0, 75, 339, 460, "004b00-101010|007b00-101010", 1, 50, 30, 20)
    if pos.x == 0 and pos.y == 0 then
        game.log.error("没有找到怪物")
        return
    end
    local tpos
    for i=1,5 do
        local newpos = _clone(pos)
        newpos.x = newpos.x + (i-1) * 10
        tpos = self:SearchMaster(newpos)
        if tpos then
            break
        end
    end
    if not tpos then
        game.log.error("没有找到法术释放点")
    end
    HardWareUtil:MoveAndClick(tpos)
    skynet.sleep(10)
    HardWareUtil:KeyPad("alt+a")
    HardWareUtil:MoveTo(_p(400,300))
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
    local list = self:RepeatFindEx(10, 0, 75, 339, 460, path,nil,0.95)
    if #list <= 0 then
        game.log.debug("没有找到要捕捉的怪物,逃跑中...")
        return self["ESCAPE"](self)
    end
    local master_pos = list[1]
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

function cmd:RepeatFind(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
    delta_color = delta_color or "000000"
    sim = sim or 1
    dir = dir or 0

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

function cmd:RepeatFindEx(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
    delta_color = delta_color or "000000"
    sim = sim or 1
    dir = dir or 0

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

return cmd