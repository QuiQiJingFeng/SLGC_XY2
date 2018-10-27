local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")
local CSVLoder = require("common.CSVLoder")

--打开小地图并 点击指定坐标
local super = require("commands.cmd_base")
local cmd = class("cmd_1103",super)
local SMALL_MAP = CSVLoder:LoadCSV("dm/res/resource/csv/small_map.csv")

function cmd:execute(name,tPos)
	if not CommandCenter:execute("1004") then
		skynet.error("打开小地图失败")
		return
	end

	local cpos = self:convertToClient(name,tPos)
	if not cpos then
		skynet.error("转换目标位置 到屏幕位置 失败")
		return 
    end
	local data = self:getBigMapAreaAndPos()
	if not data then
		skynet.error("获取当前场景、坐标失败")
		return
	end
	local playerCpos = self:convertToClient(name,cc.pos(data.x,data.y))
    
    --如果飞行成功则返回
    if self:checkFlyFlag(name,cpos,playerCpos) then
    	return true,true
    end

    HardWareUtil:MoveAndClick(cpos)

    return true
end
 

return cmd