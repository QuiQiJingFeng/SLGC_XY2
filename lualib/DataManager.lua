local DataManager = {}
local BIG_MAP_CSV = "dm/res/csv/big_map.csv"
local SMALL_MAP_CSV = "dm/res/csv/small_map.csv"
local NPC_MAP_CSV = "dm/res/csv/npc.csv"

local RE_NAME_MAP = {
    "长安东|长安城东",
    "大雁塔七层|大雁塔顶层"
}

function DataManager:CheckInvalidAreaName(name)
    local data = game.csv:LoadCSV(BIG_MAP_CSV)
    name = string.gsub(name,"%.","")
    if data[name] then
        return true
    end
    for key, value in pairs(data) do
        if string.find(name, key) then
            return true
        end
    end
    for _, renames in ipairs(RE_NAME_MAP) do
        if string.find(renames, name) then
            local list = string.split(renames, "|")
            for _, name in ipairs(list) do
                if data[name] then
                    return true
                end
            end
        end
    end
end

function DataManager:ConvertData(data,name)
    if data[name] then
        return data[name]
    end
    name = string.gsub(name,"%.","")
    for key,v in pairs(data) do
        if string.find(name,key) then
            return v
        end
    end
    --当name比地图的key小的时候,无法确定name传递过来的是否合法
    --比如说你传过来个城字,鬼知道是哪里啊
    --所以说大地图当中的名字尽量精简
    --但是有个特殊的,比如长安城东 就匹配不了 长安东
    --先暂时弄个别名表处理
    for _, renames in ipairs(RE_NAME_MAP) do
        if string.find(renames, name) then
            local list = string.split(renames, "|")
            for _, name in ipairs(list) do
                if data[name] then
                    return data[name]
                end
            end
        end
    end
    game.log.errorf("名称转换失败[%s]", name)
end

function DataManager:GetBigMapByName(name)
    local data = game.csv:LoadCSV(BIG_MAP_CSV)
    return self:ConvertData(data,name)
end

function DataManager:GetSmallMapByName(name)
    local data = game.csv:LoadCSV(SMALL_MAP_CSV)
    return self:ConvertData(data,name)
end

function DataManager:GetNPCMapByName(name)
    local data = game.csv:LoadCSV(NPC_MAP_CSV)
    return self:ConvertData(data,name)
end

return DataManager