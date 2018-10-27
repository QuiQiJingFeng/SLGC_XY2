local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")
local super = require("commands.cmd_base")
local cmd = class("cmd_1205",super)

--人族使者任务
function cmd:execute()
	if not CommandCenter:execute("1105","长安",cc.pos(383,12)) then
		skynet.error("寻路人族使者失败")
		return false
	end

	if not CommandCenter:execute("1106",cc.pos(383,12)) then
		skynet.error("对话人族使者失败")
		return false
	end

	local list = {"大唐边境","北俱芦洲","海底迷宫三"}
	for i,v in ipairs(list) do
		self:goGetYaoCai(v)
	end

	return true
end

function cmd:goGetYaoCai(areaName)
	if not CommandCenter:execute("1105",areaName,cc.pos(50,50),true) then
		skynet.error("寻路失败 ",areaName)
		return false
	end
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
			for i=1,10 do
				--检测战斗
				if CommandCenter:execute("1107","zhandou") then
					if self:checkIsHasYaoCai() then
						skynet.error("找到药材")
						return true
					end
				end
			end
		end
	end
end

function cmd:checkIsHasYaoCai()
	if not DMCenter:UseDict(1) then
		skynet.error("UseDict Failed")
		return
	end
	local text = DMCenter:Ocr(96, 127, 587+96, 362+127,"00ff00-000000",1)
	text = DMCenter:GBKToUTF8(text)
	if string.find(text,"药材") then
		return true
	end
end

return cmd