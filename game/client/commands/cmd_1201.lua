local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")
local super = require("commands.cmd_base")
local cmd = class("cmd_1201",super)
local Constants = require("common/Constants")

--领取职业任务
--1、寻路到长安 161,128
--2、对话超级管家
--3、进入到庭院 30,32

function cmd:goTingYuan()
	--寻路到长安 161,128 
	if not CommandCenter:Execute("1105","长安",_p(161,128)) then
		skynet.error("寻路到长安失败")
		return
	end
	local result = false
	--1、通过对话图标的方式找超级管家
	if CommandCenter:Execute("1106",_p(161,128)) then
		result = true
	else
		skynet.error("对话图标的方式查找超级管家失败")
	end
	--2、通过找图的方式 对话超级管家
	if not result then
	 	local path = "resource/15.bmp|resource/16.bmp|resource/17.bmp|resource/18.bmp"
	    local array = self:RepeatFindEx(1,0,0,800,600, path, "020202", 1, 0)
	    if #array > 0 then
	    	HardWareUtil:MoveAndClick(array[1])
	    	result = true
	    else
	    	skynet.error("找图的方式查找超级管家失败")
	    end
	end

 	-- 3、通过小红点的方式 对话超级管家
	if not result then
	 	if CommandCenter:Execute("1101","超级管家") then
			result = true
		else
			skynet.error("小红点的方式查找超级管家失败")
		end
	end

	if not result then
		skynet.error("所有尝试对话超级管家的措施全部失败！！！")
		return
	end

	skynet.sleep(50)
	local find = false
	for i=1,5 do
		if self:searchAndClickText("00d011-101010","庭院") then
			find = true
			break
		end
		skynet.sleep(10)
	end
	if not find then
		skynet.error("查找庭院选项失败")
		return
	end
	return true
end

function cmd:Execute()
	local config = self:GetCurAreaAndPos()
	skynet.error("name = ",config.name)
	if config.name ~= "庭院" then
		if not self:goTingYuan() then
			return
		end
	end
	skynet.sleep(100)
   	--移动到庭院30,30
   	if not CommandCenter:Execute("1105","庭院",_p(33,31)) then
		skynet.error("移动到庭院 任务台 失败")
		return
	end

	--弹出任务面板
	if not CommandCenter:Execute("1106",_p(28,32),"finger") then
		skynet.error("弹出任务面板失败1")
		return
	end
	
	skynet.sleep(50)
	local find = false
	for i=1,5 do
		find = self:searchAndClickText("00d011-101010","职业状态")
		if find then
			break
		end
		skynet.sleep(10)
	end
	--点击职业状态
	if not find then
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
	
	--弹出任务面板
	if not CommandCenter:Execute("1106",_p(28,32),"finger") then
		skynet.error("弹出任务面板失败2")
		return
	end
	skynet.sleep(100)
	--点击领取任务
	if not self:searchAndClickText("00d011-101010","领取任务") then
		skynet.error("领取任务失败")
		return
	end
 
	return "SUCCESS"
end

function cmd:checkIsCanGetTask()
	if not DMCenter:UseDict(1) then
		skynet.error("UseDict Failed")
		return
	end
	DMCenter:MoveTo(700,300)
	skynet.sleep(10)
	--解析职业状态
	local str = DMCenter:Ocr(96, 127, 587+96, 362+127,"ffffff-101010|00ff00-303030|ffff00-000000",1)
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