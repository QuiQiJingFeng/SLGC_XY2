local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)

--与指定NPC对话 小红点查找的方式
--不负责移动过程的检测,留给调用者负责检测
function cmd:Execute(npcName)
		--第一步打开小地图
		game.cmdcenter:Execute("0005")
		HardWareUtil:SendGBKString(npcName)
		local pos = self:RepeatFind(10,0,0,800,600,"3.bmp","020202",1,0)
		if not pos then
			game.log.warning("没有找到该NPC选项")
			return
		end

		pos.x = pos.x - math.random(50,80)
		pos.y = pos.y + 30
		HardWareUtil:MoveAndClick(pos)
		
		local path = "4.bmp|5.bmp"
		local array = self:RepeatFindEx(10,100,100,800,600, path, "020202",1,0)
		if #array <= 0 then
			game.log.warning("小红点被挡住了")
			return
		end

		local pos = array[1]
		HardWareUtil:MoveAndClick(pos)
		--关闭自己打开的地图
		game.cmdcenter:Execute("0006")

		return true
end

return cmd