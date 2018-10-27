local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")
local MapManager = require("common/MapManager")
local Constants = require("common/Constants")

--自动寻路=>移动到指定场景的指定坐标
local super = require("commands.cmd_base")
local cmd = class("cmd_1105",super)

function cmd:execute(sceneName,pos,stopArea)
    self.__targetSceneName = sceneName
	self.__targetPos = pos
	self.__curPos = cc.pos(0,0)
	self.__prePos = cc.pos(0,0)
	self.__stopArea = stopArea
	self.__smallMapMoveMark = false
 	self.__times = 0
	while true do
		local finish = self:update()
		if finish then
			break
		end
		skynet.sleep(100)
	end
	return true
end

--检测是否处于移动状态
function cmd:isMoving(data)
	self.__prePos = self.__curPos
	self.__curPos = cc.pos(data.x,data.y)
	local dis = distance(self.__prePos,self.__curPos)
	if dis > 0 then
		return true
	end
	return
end

function cmd:processSmallMapMoveMark(data)
	if self.__targetSceneName == data.name then
		if self.__stopArea then
			return "EXIT"
		end
		return "NEXT"
	end
	if CommandCenter:execute("1104") then
		if self.__targetSceneName == data.name then
			if self.__stopArea then
				return "EXIT"
			end
		end
	end
	if not CommandCenter:execute("1102",self.__targetSceneName,self.__targetPos) then
		skynet.error("不在目标场景的处理失败")
	end
	return "UPDATE"
end

function cmd:update()
	local data = self:getBigMapAreaAndPos()
	if not data then
		return
	end
	if self:isMoving(data) then
		if self.__targetSceneName == data.name then
			if self.__stopArea then
				self:setForbidFlyFlag(false)
				return true
			end
		end
		return
	end
	if not self.__smallMapMoveMark then
		local ret = self:processSmallMapMoveMark(data)
		if ret == "EXIT" then
			--到目标点之后要降落下来
			self:flyDown()
			if not CommandCenter:execute("1002") then
				skynet.error("关闭所有地图失败")
				return false
			end
			self:setForbidFlyFlag(false)
			return true
		elseif ret == "UPDATE" then
			return
		elseif ret == "NEXT" then
		end
	end

	local isInPos = false
	--是否到达目标场景的目标点
	if self.__targetSceneName == data.name then
		local distance = distance(self.__targetPos,self.__curPos)
		if distance <= 10 then
			isInPos = true
		end
	end
	if isInPos then
		--到目标点之后要降落下来
		self:flyDown()
		if not CommandCenter:execute("1002") then
			skynet.error("关闭所有地图失败")
			return false
		end
	
		return true
	end
	if self.__smallMapMoveMark then
		self.__times = self.__times + 1
		if self.__times <= 5 then
			return
		end
		self:setForbidFlyFlag(true)
		HardWareUtil:KeyPad("alt+c")
		self.__smallMapMoveMark = nil
		self.__times = 0
		return
	end

	self.__smallMapMoveMark = true
	local success,fly = CommandCenter:execute("1103",self.__targetSceneName,self.__targetPos)
	if not success then
		skynet.error("小地图移动失败")
		self.__smallMapMoveMark = nil
		self.__times = 0
	end
	skynet.error("fly -======>>>",fly)
	if fly then
		self.__smallMapMoveMark = nil
		self.__times = 0
		return
	end
	self:setForbidFlyFlag(false)
	return
end

return cmd