local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")
local super = require("commands.cmd_base")
local cmd = class("cmd_1208",super)

--李世民任务
function cmd:execute()
	if not CommandCenter:execute("1105","皇宫",cc.pos(126,50),true) then
		skynet.error("寻路李世民失败")
		return false
	end

	if not CommandCenter:execute("1101","李世民") then
		skynet.error("对话李世民失败")
		return false
	end

	if not CommandCenter:execute("1105","斧头帮总部",cc.pos(50,50),true) then
		skynet.error("寻路李世民失败")
		return false
	end
	
	if self:process() then
		if not CommandCenter:execute("1105","皇宫",cc.pos(126,50),true) then
			skynet.error("寻路李世民失败")
			return false
		end

		if not CommandCenter:execute("1101","李世民") then
			skynet.error("对话李世民失败")
			return false
		end
	end

	return true
end


function cmd:process()
	local leftPos = cc.pos(50,500)
	local rightPos = cc.pos(750,250)
	local curPos
	while true do
		if curPos == leftPos then
			curPos = rightPos
		else
			curPos = leftPos
		end
		for i=1,1 do
			HardWareUtil:MoveToRightClick(curPos)
			for i=1,5 do
				--检测战斗
				if CommandCenter:execute("1107","zhandou") then
				
					local text = self:parseTask("职业任务")
					if string.find(text,"李世民") then
						return true
					end
				end
			end
		end
	end
end
return cmd