local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")
local super = require("commands.cmd_base")
local cmd = class("cmd_1106",super)

--目標點附近才能使用這個方法,用來查找對話標誌
function cmd:execute(targetPos,type)
	local playerCpos,playerPos = self:getCurPlayerPos()
	local dx = (targetPos.x - playerPos.x) * 20
	local dy = (playerPos.y - targetPos.y) * 20

	local x = playerCpos.x + dx
	local y = playerCpos.y + dy - math.random(5,10)

	local targetCPos = cc.pos(x,y)

	local findChat = false
	local unit = 10
	for i=1,8 do
		HardWareUtil:MoveTo(targetCPos.x,targetCPos.y)
		skynet.sleep(20)
		if type == "finger" then
	    	local path = "resource/finger_1.bmp"
	    	local pos = DMCenter:FindPic(0,0,800,600,path,"020202",1,0.8)
	      	if pos.x ~= 0 or pos.y ~= 0 then
	      		findChat = true
	      		break
	      	end
	    else
	    	local path = "resource/chat_1.bmp|resource/chat_2.bmp|resource/chat_3.bmp|resource/chat_4.bmp"
		    local ret = DMCenter:FindPicExS(0,0,800,600, path, "020202", 1, 0)
		    if not (ret == "") then
		    	findChat = true
		    	break
		    end
	    end
	   	targetCPos.y = targetCPos.y - unit
	end
	if not findChat then
		return false
	end
	HardWareUtil:MoveAndClick(targetCPos)
	return true
end

return cmd