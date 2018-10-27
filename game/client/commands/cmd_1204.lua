local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local super = require("commands.cmd_base")
local cmd = class("cmd_1204",super)

--鬼族使者任务
function cmd:execute()
	if not CommandCenter:execute("1105","长安",cc.pos(374,16)) then
		skynet.error("寻路鬼族使者失败")
		return false
	end

	if not CommandCenter:execute("1106",cc.pos(374,16)) then
		skynet.error("对话鬼族使者失败")
		return false
	end

	if not CommandCenter:execute("1105","长安",cc.pos(215,181)) then
		skynet.error("寻路昆仑镜位置失败")
		return false
	end

	HardWareUtil:KeyPad("alt+e")
	local path = "resource/task_icon_close.bmp|resource/task_icon_open.bmp"
	local list = self:repeatFindEx(10,300, 300, 600, 500, path, "020202",1,0)
	if #list <= 0 then
		skynet.error("没有找到任何一张图片")
		return false
	end
	if #list >= 2 then
		skynet.error("失败,找到的图片多于两张")
		return false
	end

	local obj = list[1]
	if obj.inxex == 0 then
		obj.x = obj.x + 20
		HardWareUtil:MoveAndClick(obj)
	end
	local pos = self:repeatFind(10,200, 300, 600, 500, "resource/kunlunjing.bmp", "020202",1,0)
	HardWareUtil:MoveAndClick(pos)
	skynet.sleep(50)

	local text = self:parseTask("职业任务")
	local iter = string.gmatch(text,"(%d+)")
	local x = tonumber(iter())
	local y = tonumber(iter())

	if not CommandCenter:execute("1105","长安",cc.pos(x,y)) then
		skynet.error("寻路武状元失败")
		return false
	end
	if not CommandCenter:execute("1106",cc.pos(x,y)) then
		skynet.error("对话武状元失败")
		return false
	end
	--战斗检测
	if not CommandCenter:execute("1107","zhandou") then
 		skynet.error("没有检测到战斗")
 		return
 	end

 	local text = self:parseTask("职业任务")
	local iter = string.gmatch(text,"(%d+)")
	local x = tonumber(iter())
	local y = tonumber(iter())

	if not CommandCenter:execute("1105","洛阳",cc.pos(x,y)) then
		skynet.error("寻路文状元失败")
		return false
	end
	if not CommandCenter:execute("1106",cc.pos(x,y)) then
		skynet.error("对话文状元失败")
		return false
	end

	local find = false
	for i=1,5 do
		if self:searchAndClickText("00d011-101010","文采不错") then
			find = true
			break
		end
		skynet.sleep(10)
	end
	if not find then
		skynet.error("开始答题失败")
		return
	end
	skynet.sleep(100)
	while true do
		local list = DMCenter:GetWordsNew(96, 127, 587+96, 362+127,"00d011-101010|ffffff-000000",1)
		if #list <= 0 then
			skynet.error("识别诗词完毕,没有找到新的诗词")
			return true
		end
		local value = CommandCenter:execute("1108",list[1].word)
		local finish = false
		for i,v in ipairs(list) do
			if string.find(v.word,value) then
				HardWareUtil:MoveAndClick(v.pos)
				finish = true
			end
		end
		if not finish then
			skynet.error("没有找到匹配的诗词")
			return
		end
		skynet.sleep(100)
	end
end

return cmd