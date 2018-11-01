local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)

--李世民任务
function cmd:Execute()
	-- self:ChatLiShiMin()
	-- skynet.sleep(50)
	game.cmdcenter:Execute("1105", "斧头帮总部", _p(50, 50),true)
	if self:process() then
		self:ChatLiShiMin()
	end

	return true
end

function cmd:ChatLiShiMin()
	--首先检查一下有没有飞往皇宫的航班
	--打开对应的小地图
	game.cmdcenter:Execute("1102", "皇宫", _p(126, 50), true,true)
	if self:CheckFlyFlag("皇宫", _p(140, 60), false, true) then
		skynet.sleep(30)
		game.cmdcenter:Execute("1106", _p(68, 40))
	else
		game.cmdcenter:Execute("1105", "皇宫", _p(126, 50), true)
		game.cmdcenter:Execute("1101", "李世民")
	end
end

function cmd:process()
	local list = {
		{"斧头帮总部", _p(26, 112)},
		{"斧头帮总部", _p(88, 44)}
	}
	
	self:SetForbidFlyFlag(true)
	local pos = self:GetCurAreaAndPos()
	local x,y = pos.x,pos.y
	local idx = 1
	while true do
		local newpos = {}
		newpos.x = x + math.random(10,30) * (math.random(0,1)>0.5 and 1 or -1)
		newpos.y = y + math.random(10, 30) * (math.random(0, 1) > 0.5 and 1 or -1)
		game.cmdcenter:Execute("1103", "斧头帮总部",newpos)
		local finish = self:WaitMoveEnd()
		if not finish and game.cmdcenter:TestExecute("1107","zhandou") then
			local text = self:parseTask("职业任务")
			if string.find(text, "李世民") then
				self:SetForbidFlyFlag(false)
				return true
			end
		end
		skynet.sleep(10)
	end
end
return cmd