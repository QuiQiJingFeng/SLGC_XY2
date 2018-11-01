local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)


--目標點附近才能使用這個方法,用來查找對話標誌
function cmd:Execute(targetPos,type)
	local data = self:GetCurAreaAndPos()
	if not data then
		game.log.warning("获取地图名称和坐标失败")
		return
	end
	local dx = (targetPos.x - data.x) * 20
	local dy = (data.y - targetPos.y) * 20
	local playerPixelPos = self:getPlayerPixelPos()
	if not playerPixelPos then
		return game.log.warning("获取玩家像素位置失败")
	end
	local x = playerPixelPos.x + dx
	local y = playerPixelPos.y + dy

	local targetCPos = _p(x,y)

	local findChat = false
	local unit = 10
	for i=1,10 do
		HardWareUtil:MoveTo(targetCPos.x,targetCPos.y)
		skynet.sleep(20)
		if type == "finger" then
	    	local path = "finger_1.bmp"
	    	local pos = game.dmcenter:FindPic(0,0,800,600,path,"020202",1,0.8)
	      	if pos.x ~= 0 or pos.y ~= 0 then
	      		findChat = true
	      		break
	      	end
	    else
	    	local path = "chat_1.bmp|chat_2.bmp|chat_3.bmp|chat_4.bmp"
		    local ret = game.dmcenter:FindPicExS(0,0,800,600, path, "020202", 1, 0)
		    if not (ret == "") then
		    	findChat = true
		    	break
		    end
	    end
	   	targetCPos.y = targetCPos.y - unit
	end
	if not findChat then
		return
	end
	HardWareUtil:MoveAndClick(targetCPos)
	return true
end

return cmd