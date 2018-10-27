local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")
local CSVLoder = require("common.CSVLoder")
local super = require("commands.cmd_base")
local cmd = class("cmd_1102",super)
local BIG_MAP = CSVLoder:LoadCSV("dm/res/resource/csv/big_map.csv")
local SMALL_MAP = CSVLoder:LoadCSV("dm/res/resource/csv/small_map.csv")

--通过大地图打开小地图并 点击指定坐标
function cmd:execute(name,tPos)
	if not CommandCenter:execute("1001") then
		skynet.error("打开大地图失败")
		return
	end
	local tempName = name
	do
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
	end

    local data = self:getArrayDataByKey("name",tempName,BIG_MAP)
	if not data then
		skynet.error("无法获得大地图数据 : ",name)
		return
	end

	local x = data.x + math.random(1,data.dx)
    local y = data.y + math.random(1,data.dy)
	HardWareUtil:MoveAndClick(cc.pos(x, y))

 	--检测小地图是否打开
	if not self:isSmallMapOpen(20) then
		skynet.error("没有检测到小地图打开")
		return
	end

	local cpos = self:convertToClient(name,tPos,true)
	if not assert(cpos,"转换目标位置 到屏幕位置 失败") then
		return 
    end

    local data = self:getBigMapAreaAndPos()
	if not data then
		skynet.error("获取当前场景名称和坐标失败")
		return
	end
	local playerCpos = self:convertToClient(name,cc.pos(data.x,data.y),true)
    --飞行棋处理 因为飞行结束后会自动关闭小地图,所以这里直接返回
    if self:checkFlyFlag(name,cpos,playerCpos) then
    	return true
    end

    HardWareUtil:MoveAndClick(cpos)

    return true
end

 
return cmd