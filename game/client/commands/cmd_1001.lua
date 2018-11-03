local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)

--领取职业任务
--1、寻路到长安 161,128
--2、对话超级管家
--3、进入到庭院 30,32

function cmd:goTingYuan()
    --打开长安的小地图
    game.cmdcenter:Execute("0009","长安",_p(50,50),false)
    --1、飞行棋飞到长安
    self:CheckFlyFlag("长安", _p(161,128),"big")
	--寻路到长安 161,128 
    game.cmdcenter:Execute("0012","长安",_p(161,128))
    --1、通过对话图标的方式找超级管家
    local result = game.cmdcenter:TestExecute("0013",_p(161,128))
	
	--2、通过找图的方式 对话超级管家
	if not result then
	 	local path = "resource/15.bmp|resource/16.bmp|resource/17.bmp|resource/18.bmp"
	    local array = self:RepeatFindEx(1,0,0,800,600, path, "020202", 1, 0)
	    if #array > 0 then
	    	HardWareUtil:MoveAndClick(array[1])
	    	result = true
	    end
	end

 	-- 3、通过小红点的方式 对话超级管家
    if not result then
        game.cmdcenter:TestExecute("0010","超级管家")
	end

	skynet.sleep(50)
	if not self:searchAndClickText("00d011-101010","庭院") then
		skynet.error("查找庭院选项失败")
		return
	end
	return true
end

function cmd:Execute()
	local config = self:GetCurAreaAndPosWithCapther()
	skynet.error("name = ",config.name)
	if config.name ~= "庭院" then
		if not self:goTingYuan() then
			return
		end
	end
	skynet.sleep(100)
    --移动到庭院30,30
    game.cmdcenter:Execute("0011","庭院",_p(33,31))
    --关闭所有地图
    game.cmdcenter:Execute("0006")
   	--检测是否移动停止,停止则返回
    game.cmdcenter:Execute("0001","FIGHT")

    local pos = game.data:GetNPCMapByName("香炉")
    --弹出任务面板
    game.cmdcenter:Execute("0013",pos,"finger")
    skynet.sleep(50)
	--点击职业状态
	if not self:searchAndClickText("00d011-101010","职业状态") then
		skynet.error("查看职业状态失败")
		return
	end
	skynet.sleep(100)
	local ret = self:checkIsCanGetTask()
	if ret == "FINISH" then
		return ret
	elseif ret ~= "SUCCESS" then
		return
	end
	skynet.sleep(100)
    
    local pos = game.data:GetNPCMapByName("香炉")
	--弹出任务面板
    game.cmdcenter:Execute("0013",pos,"finger")
    
	skynet.sleep(100)
	--点击领取任务
	if not self:searchAndClickText("00d011-101010","领取任务") then
		skynet.error("领取任务失败")
		return
	end
 
	return "SUCCESS"
end

function cmd:checkIsCanGetTask()
    game.dict:ChangeDict("ST_11")
    HardWareUtil:MoveTo(_p(700,300))
    --解析职业状态
	local str = game.dmcenter:Ocr(96, 127, 587+96, 362+127,"ffffff-101010|00ff00-303030|ffff00-000000",1)
 	if not string.find(str,"制符") then
		skynet.error("查找字符失败")
		return
 	end
 	local value = string.gmatch(str,"真元值.-(%d+)")()
 	--当前真元
	local zhenyuan = tonumber(value)
	local value = string.gmatch(str,"最大值.-(%d+)")()
	--最大真元值
	local maxZhenyuan = tonumber(value)

	local value = string.gmatch(str,"庭院灵气值.-(%d+)")()
	--当前灵气值
	local lingqi = tonumber(value)
	skynet.error("当前真元:",zhenyuan)
	skynet.error("最大真元值:",maxZhenyuan)
	skynet.error("灵气值:",lingqi)
	local delt = 200
	if zhenyuan + delt >= maxZhenyuan then
		skynet.error("真元值满了")
		return "FINISH"
	end

	if lingqi < delt then
		skynet.error("灵气值不够了")
		return "FINISH"
	end

	HardWareUtil:MoveAndClick(_p(382,259))
	return "SUCCESS"
end

return cmd