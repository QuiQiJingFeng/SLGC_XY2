local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")
local super = require("commands.cmd_base")
local cmd = class("cmd_1203",super)

--勾魂马面任务
function cmd:execute()
	if not CommandCenter:execute("1105","轮回司",cc.pos(58,28)) then
		skynet.error("寻路轮回司失败")
		return false
	end

	if not CommandCenter:execute("1106",cc.pos(57,33)) then
		skynet.error("对话勾魂使者失败")
		return false
	end
	skynet.sleep(30)
	--获取任务描述
	local npcName = self:parseTask("职业任务")
	skynet.error("NPC NAME = ",npcName)
	local npcMap = self:getNpcMap()
	local select = nil
	for _,obj in pairs(npcMap) do
		if obj.name == npcName then
			select = obj
		end
	end
	if not select then
		skynet.error("NOT NPC CONFIG==>",npcName)
		return
	end

	--禁止使用飞行棋
	self:setForbidFlyFlag(true)
	if not CommandCenter:execute("1105",select.area,cc.pos(select.x + 3,select.y+3),true) then
		skynet.error("勾魂 任务 寻路失败 => ",select.area, "x = ",select.x,"y = ",select.y)
		return false
	end

	--解开禁止
	self:setForbidFlyFlag(false)

	if not CommandCenter:execute("1101",npcName) then
		skynet.error("小红点找人失败")
		return false
	end
	local find = false
	for i=1,300 do
		find = self:searchAndClickText("00d011-101010","伏羲琴")
		if find then
			break
		end
		skynet.sleep(10)
	end
	if not find then
		skynet.error("使用伏羲琴失败")
		return
	end

	return true
end

return cmd