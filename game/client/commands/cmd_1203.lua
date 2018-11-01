local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)


--勾魂马面任务
function cmd:Execute()
	--1、前往轮回司
	game.cmdcenter:Execute("1105", "轮回司", _p(58, 28))
	
	--2、对话话勾魂使者
	game.cmdcenter:Execute("1106", _p(57, 33))
	skynet.sleep(30)
	--获取任务描述
	local npcName = self:parseTask("职业任务")
	game.log.info("勾魂任务NPC=>"..(npcName or ""))
	local npcMap = game.data:getNPCMap()
	local select = npcMap[npcName]
	if not select then
		for i=1,1 do
			for name, obj in pairs(npcMap) do
				if string.find(npcName, name) then
					select = obj
				end
			end
			
			if select then
				break
			end

			game.log.warningf("NPC [%s]配置不存在", npcName)
			return
		end
	end

	--禁止使用飞行棋
	self:SetForbidFlyFlag(true)
	--寻路查找任务人
	game.cmdcenter:Execute("1105", select.area, _p(select.x + 3, select.y + 3), true)
	--解开禁止
	self:SetForbidFlyFlag(false)
	--小红点找人
	game.cmdcenter:Execute("1101", npcName)

	local find = false
	for i=1,300 do
		find = self:searchAndClickText("00d011-101010","伏羲琴")
		if find then
			break
		end
		skynet.sleep(30)
	end
	if not find then
		game.log.warning("使用伏羲琴失败")
		return
	end

	return true
end

return cmd