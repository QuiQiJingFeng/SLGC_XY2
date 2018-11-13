local skynet = require "skynet"
local cmd_base = {}

function cmd_base:loopCall(num,ptime,func)
    num = num or 1
    ptime = ptime or 10
    for i=1,num do
        local ret = func()
        if ret then return ret end
        skynet.sleep(ptime)
    end
end

function cmd_base:repeateFind(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir,time)
    return self:loopCall(num,time,function() 
        local pos = game.dmcenter:FindPic(x1, y1, x2, y2, pic_name, delta_color, sim, dir)
        if pos.x ~= 0 or pos.y ~= 0 then return end
        return pos
    end)
end

function cmd_base:repeateFindEx(num, x1, y1, x2, y2, pic_name,delta_color,sim,dir,time)
    return self:loopCall(num,time,function()
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

function cmd_base:repeateFindExS(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir,time)
    return self:loopCall(num,time,function() 
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

function cmd_base:repeateSearchWords(num,font,text,x1, y1, x2, y2,corlor_format,sim,time)
    game.dict:ChangeDict(font)
    return self:loopCall(num,time,function()
        local list = game.dmcenter:GetWordsNew(x1, y1, x2, y2, corlor_format, sim)
        if #list <= 0 then return end
        for _, obj in pairs(list) do
            if string.find(obj.word,text) then
                return obj
            end
        end
    end)
end

function cmd_base:repeateNoFind(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir,time)
    return self:loopCall(num,time,function() 
        return not self:repeateFind(1, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
    end)
end

function cmd_base:repeateNoFindEx(num, x1, y1, x2, y2, pic_name,delta_color,sim,dir,time)
    return self:loopCall(num,time,function() 
        return not self:repeateFindEx(1, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
    end)
end

function cmd_base:repeateNoFindExS(num, x1, y1, x2, y2, pic_name,delta_color,sim,dir,time)
    return self:loopCall(num,time,function() 
        return not self:repeateFindExS(1, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
    end)
end

function cmd_base:parseTask(taskName,corlor_format)
    HardWareUtil:KeyPad("alt+q")
    skynet.sleep(50)
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
        HardWareUtil:MoveAndClick(select.pos)
        skynet.sleep(20)
    end
    select.pos.y = select.pos.y + 20
    HardWareUtil:MoveAndClick(select.pos)
    skynet.sleep(20)
    corlor_format = corlor_format or "00ff00-101010"
    local str = game.dmcenter:Ocr(371, 158, 275 + 371, 293 + 158, corlor_format, 1)
    HardWareUtil:KeyPad("alt+q")
    skynet.sleep(50)
    
    return str
end
return cmd_base