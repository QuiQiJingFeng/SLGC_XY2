local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local cmd_base = {}

function cmd_base:LoopCall(num,ptime,func)
    num = num or 1
    ptime = ptime or 10
    for i=1,num do
        local ret1,ret2 = func()
        if ret1 then return ret1,ret2 end
        skynet.sleep(ptime)
    end
end

function cmd_base:RepeateFind(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir,time)
    return self:LoopCall(num,time,function() 
        local pos = game.dmcenter:FindPic(x1, y1, x2, y2, pic_name, delta_color, sim, dir)
        if pos.x == 0 or pos.y == 0 then return end
        return pos
    end)
end

function cmd_base:RepeateFindEx(num, x1, y1, x2, y2, pic_name,delta_color,sim,dir,time)
    return self:LoopCall(num,time,function()
            local ret = game.dmcenter:FindPicEx(x1, y1, x2, y2, pic_name, delta_color, sim, dir)
            if ret == "" then return end
            local array = {}
            local list = string.split(ret, "|")
            for _, conf in ipairs(list) do
                local temp = string.split(conf, ",")
                local data = {index = tonumber(temp[1]), x = tonumber(temp[2]), y = tonumber(temp[3])}
                table.insert(array, data)
            end
            if #array <= 0 then return end
            return array
    end)
end

function cmd_base:RepeateFindExS(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir,time)
    return self:LoopCall(num,time,function() 
        local ret = game.dmcenter:FindPicExS(x1, y1, x2, y2, pic_name, delta_color, sim, dir)
        if ret == "" then return end
        local array = {}
        local list = string.split(ret, "|")
        for _, conf in ipairs(list) do
            local temp = string.split(conf, ",")
            local data = {name = temp[1], x = tonumber(temp[2]), y = tonumber(temp[3])}
            table.insert(array, data)
        end
        if #array <= 0 then return end
        return array
    end)
end

function cmd_base:RepeateSearchWords(num,font,text,x1, y1, x2, y2,corlor_format,sim,time)
    game.dict:ChangeDict(font)
    return self:LoopCall(num,time,function()
        local list = game.dmcenter:GetWordsNew(x1, y1, x2, y2, corlor_format, sim)
        if #list <= 0 then return end
        for _, obj in pairs(list) do
            if string.find(obj.word,text) then
                skynet.error("obj.word = ",obj.word)
                return obj,list
            end
        end
    end)
end

function cmd_base:RepeateNoFind(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir,time)
    return self:LoopCall(num,time,function() 
        return not self:RepeateFind(1, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
    end)
end

function cmd_base:RepeateNoFindEx(num, x1, y1, x2, y2, pic_name,delta_color,sim,dir,time)
    return self:LoopCall(num,time,function() 
        return not self:RepeateFindEx(1, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
    end)
end

function cmd_base:RepeateNoFindExS(num, x1, y1, x2, y2, pic_name,delta_color,sim,dir,time)
    return self:LoopCall(num,time,function() 
        return not self:RepeateFindExS(1, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
    end)
end

function cmd_base:ParseTask(taskName,corlor_format)
    HardWareUtil:KeyPad("alt+q")
    skynet.sleep(50)
    game.dict:ChangeDict("ST_11")
    local list
    local select = nil
    for i = 1, 5 do
        list = game.dmcenter:GetWordsNew(149, 160, 149 + 149, 234 + 160, "ffffff-101010|d2d000-303030|989413-303030", 1)
        for i, obj in ipairs(list) do
            if string.find(obj.word, taskName) then
                select = obj
                break
            end
        end
        if select then
            break
        end
        local hasOpen = false
        for i = #list, 1, -1 do
            local obj = list[i]
            if string.find(obj.word, "★") then
                HardWareUtil:MoveAndClick(obj.pos)
                hasOpen = true
            end
        end
 
        if not hasOpen then
            HardWareUtil:KeyPad("alt+q")
            skynet.sleep(50)
            return
        end
        HardWareUtil:MoveTo(_p(math.random(600,800),math.random(400,500)))
        skynet.sleep(10)
    end
    if not select then
        HardWareUtil:KeyPad("alt+q")
        skynet.sleep(50)
        return
    end

    if string.find(select.word, "☆") then
        HardWareUtil:MoveAndClick(select)
        skynet.sleep(20)
    end
    select.y = select.y + 20
    HardWareUtil:MoveAndClick(select)
    skynet.sleep(20)
    corlor_format = corlor_format or "00ff00-101010"
    local str = game.dmcenter:Ocr(371, 158, 275 + 371, 293 + 158, corlor_format, 1)
    HardWareUtil:KeyPad("alt+q")
    skynet.sleep(50)
    
    return str
end

function cmd_base:ErrorProcess(battleType)
    battleType = battleType or "FIGHT"
    --错误处理函数
    --无法获取场景名称的情况有两种
    --1、进入战斗的时候不会显示
    --2、当被遮挡的时候会有问题
    --先检测是否是战斗导致的,如果是则处理战斗,战斗参数设置为逃跑
    game.log.info("获取场景名称失败,尝试进入战斗")
    if not game.cmdcenter:TestExecute("battle", battleType) then
        game.log.error("进入战斗失败,遇到未知的情况")
    else
        return "FIGHT" --战斗处理完成
    end
end

function cmd_base:WaitMoveEnd(battleType)
    local prePos = _p(0, 0)
    while true do
        local pos = game.map:GetCurAreaAndPos()
        if not pos then
            return self:ErrorProcess(battleType)
        end
        local dist = _distance(prePos, pos)
        if dist == 0 then
            return "MOVE_END"
        end
        prePos = pos
        skynet.sleep(100)
    end
end

function cmd_base:MetchResource(path,filter)
    local cmd = "ls dm/res/"..path
    local file = io.popen(cmd)
    local content = file:read("*a")
    file:close()
    local list = string.split(content,"\n")
    local array = {}
    for k,v in ipairs(list) do
        if string.find(v,filter) then
            table.insert(array,v)
        end
    end
    if #array <= 0 then
        game.log.error("没有匹配的图片")
    end
    return table.concat(array,"|")
end

return cmd_base