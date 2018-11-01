local DictManager = {}

local DICTS = {
    [0] = "dict/ST_9.txt",      -- 宋体9号
    [1] = "dict/ST_11.txt",     -- 宋体11号
    [2] = "dict/ST_B_11.txt",   -- 宋体11号 粗体
    [3] = "dict/ST_10.txt"      -- 宋体10号 
}

--设置字典信息
for index, path in pairs(DICTS) do
    local result = game.dmcenter:SetDict(index, path)
    if not result then
        game.log.error("字典设置失败")
    end
end
DictManager["ST_9"] = 0
DictManager["ST_11"] = 1
DictManager["ST_B_11"] = 2
DictManager["ST_10"] = 3


function DictManager:ChangeDict(key)
    if not DictManager[key] then
        game.log.error("字典参数错误")
        return
    end
    if not game.dmcenter:UseDict(DictManager[key]) then
        game.log.error("切换字典失败")
        return
    end
end

return DictManager