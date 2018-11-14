local HardWareUtil = require "HardWareUtil"
local skynet = require "skynet"
local super = require "command.cmd_base"
local ItemManager = class("ItemManager", super)

local cache = {}

function ItemManager:Distinguish(key,CONTENT_RECT)
    if cache[key] then
        return cache[key]
    end
    
    local path = "items/"..game.dmcenter:UTF8ToGBK(key)..".bmp"
    local list = self:RepeateFindEx(10,CONTENT_RECT[1],CONTENT_RECT[2],CONTENT_RECT[3],CONTENT_RECT[4], path, "020202", 1.0, 0)
    if #list <= 0 then
        game.log.error("item num <= 0")
    end
    cache[key] = list

    return list
end

function ItemManager:GetKongMingDengDetail(list)
    game.dict:ChangeDict("ST_10")
    for _,obj in ipairs(list) do
        HardWareUtil:MoveTo(obj)
        local rect = _rect(obj,300)
        skynet.sleep(300)
        local times = game.dmcenter:Ocr(rect[1],rect[2],rect[3],rect[4],"ff0000-101010", 1)
        local iter = string.gmatch(times,"%d+")
        local times = tonumber(iter())
        if not times then
            game.log.error("没有获取到孔明灯剩余次数")
        end
        --剩余次数
        obj.times = times
        for i=1,1 do
            local destributes = game.dmcenter:GetWordsNew(rect[1],rect[2],rect[3],rect[4],"00ff00-101010", 1)
            if not destributes or #destributes <= 0 then
                obj.num = 0
                break
            end
            local lastText =destributes[#destributes].word
            if string.find(lastText,"无法交易") then
                table.remove(destributes)
            end
            --坐标数量
            obj.num = #destributes
        end
    end

    return list
end

function ItemManager:UpdateCache(key,value)
    cache[key] = value
end

return ItemManager