local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")

--查找黄色提示文字并点击
local super = require("commands.cmd_base")
local cmd = class("cmd_1104",super)

function cmd:execute()
	if not DMCenter:UseDict(2) then
		skynet.error("字库2切换失败")
		return
	end
	local list = DMCenter:GetWordsNew(135,230,362,415,"ffff00-000000",1.0)
	if #list <= 0 then
		skynet.error("没有找到黄色提示")
		return true
	end
	local obj = list[1]
	obj.pos.x = obj.pos.x + math.random(10,50)
	obj.pos.y = obj.pos.y + math.random(3,8)
	HardWareUtil:MoveAndClick(obj.pos)
	skynet.sleep(100)
	
    return true
end
 

return cmd