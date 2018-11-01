local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)


--人族使者任务
function cmd:Execute()
	--寻找人族使者
	game.cmdcenter:Execute("1105", "长安", _p(383, 12))
	--对话人族使者
	game.cmdcenter:Execute("1106", _p(383, 12))

	local list = {"大唐边境","北俱芦洲","海底迷宫三层"}

	for i,v in ipairs(list) do
		self:goGetYaoCai(v)
	end

	return true
end

function cmd:goGetYaoCai(areaName)
	game.cmdcenter:Execute("1105", areaName, _p(30, 40),true)
	local data = self:GetCurAreaAndPos()
	if not data then
		game.log.warning("获取当前地图和坐标失败")
		return
	end
	local list = {
		{data.name, _p(20, 20)},
		{data.name, _p(60, 40)}
	}
	self:SetForbidFlyFlag(true)
	local idx = 1
	while true do
		game.cmdcenter:Execute("1103", table.unpack(list[idx]))
		local finish = self:WaitMoveEnd()
		if not finish then
			if game.cmdcenter:TestExecute("1107", "zhandou") then
				if self:checkIsHasYaoCai() then
					skynet.error("找到药材")
					return true
				end
			end
		end
		idx = idx + 1
		if idx == 3 then
			idx = 1
		end
	end



	-- local playerPixelPos = self:getPlayerPixelPos()
	-- playerPixelPos.x = playerPixelPos.x - 50
	-- playerPixelPos.y = playerPixelPos.y + 50
	-- local leftPos = _p(playerPixelPos.x-50, playerPixelPos.y)
	-- local rightPos = _p(playerPixelPos.x - 50, playerPixelPos.y)
	-- local curPos
	-- while true do
	-- 	if curPos == leftPos then
	-- 		curPos = rightPos
	-- 	else
	-- 		curPos = leftPos
	-- 	end
	-- 	for i=1,1 do
	-- 		HardWareUtil:MoveToRightClick(curPos)
	-- 		for i=1,10 do
	-- 			--检测战斗
	-- 			if game.cmdcenter:Execute("1107","zhandou") then
	-- 				if self:checkIsHasYaoCai() then
	-- 					skynet.error("找到药材")
	-- 					return true
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end
end

function cmd:checkIsHasYaoCai()
	if not game.dmcenter:UseDict(1) then
		skynet.error("UseDict Failed")
		return
	end
	local text = game.dmcenter:Ocr(96, 127, 587+96, 362+127,"00ff00-000000",1)
	if string.find(text,"药材") then
		return true
	end
end

return cmd