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

function cmd_base:repeateFind(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
    return self:loopCall(num,10,function() 
        local pos = game.dmcenter:FindPic(x1, y1, x2, y2, pic_name, delta_color, sim, dir)
        if pos.x ~= 0 or pos.y ~= 0 then return end
        return pos
    end)
end

function cmd_base:repeateFindEx(num, x1, y1, x2, y2, pic_name,delta_color,sim,dir)
    return self:loopCall(num,10,function()
            local ret = game.dmcenter:FindPicEx(x1, y1, x2, y2, pic_name, delta_color, sim, dir)
            if ret ~= "" then return end
            local array = {}
            local list = string.split(ret, "|")
            for _, conf in ipairs(list) do
                local temp = string.split(conf, ",")
                local data = {index = tonumber(temp[1]), x = tonumber(temp[2]), y = tonumber(temp[3])}
                table.insert(array, data)
            end
            if #array <= 0 then return end
            return true
    end)
end

function cmd_base:repeateFindExS(num, x1, y1, x2, y2, pic_name, delta_color, sim, dir)
    return self:loopCall(num,10,function() 
        local ret = game.dmcenter:FindPicExS(x1, y1, x2, y2, pic_name, delta_color, sim, dir)
        if ret ~= "" then return end
        local array = {}
        local list = string.split(ret, "|")
        for _, conf in ipairs(list) do
            local temp = string.split(conf, ",")
            local data = {name = temp[1], x = tonumber(temp[2]), y = tonumber(temp[3])}
            table.insert(array, data)
        end
        if #array <= 0 then return end
        return true
    end)
end

function cmd_base:repeateSearchWords(num,font,text,x1, y1, x2, y2,corlor_format,sim)
    game.dict:ChangeDict(font)
    return self:loopCall(num,10,function()
        local list = game.dmcenter:GetWordsNew(x1, y1, x2, y2, corlor_format, sim)
        if #list <= 0 then return end
        for _, obj in pairs(list) do
            if string.find(obj.word,text) then
                return obj
            end
        end
    end)
end

return cmd_base