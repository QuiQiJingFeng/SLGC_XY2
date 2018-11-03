local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)


--人族使者任务
function cmd:Execute()
    self:GoTo("长安", _p(383, 12))
    --对话人族使者
    game.cmdcenter:Execute("0013", _p(383, 12))
    skynet.sleep(100)
	local list = {
            {name = "大唐边境",pos = _p(170,222)},
            {name = "北俱芦洲",pos = _p(120,80)},
            {name = "海底迷宫三层",pos = _p(40,20)}
        }
	for i,v in ipairs(list) do
		self:goGetYaoCai(v)
	end
    self:GoTo("长安", _p(383, 12))
    game.cmdcenter:Execute("0013", _p(383, 12))

	return true
end

function cmd:goGetYaoCai(conf)
    local areaName = conf.name
    local pos = conf.pos
    self:GoTo(areaName,pos)
	local data = self:GetCurAreaAndPosWithCapther()
    local x ,y
    while true do
        local zf = math.random(0,1) > 0.5 and 1 or -1
        x = data.x + math.random(10,20) * zf
        y = data.y + math.random(10,20) * zf
        game.cmdcenter:Execute("0011",data.name,_p(x,y))
        --检测是否移动停止,停止则返回
        local ret = game.cmdcenter:Execute("0001","FIGHT")
        game.cmdcenter:Execute("0006")
        if self:checkIsHasYaoCai() then
            skynet.error("找到药材")
            return true
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
    game.dict:ChangeDict("ST_11")
	local text = game.dmcenter:Ocr(96, 127, 587+96, 362+127,"00ff00-000000",1)
	if string.find(text,"药材") then
		return true
	end
end

return cmd