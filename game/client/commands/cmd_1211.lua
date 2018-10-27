local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")
local super = require("commands.cmd_base")
local cmd = class("cmd_1211",super)

--大大王任务
function cmd:execute()
	if not CommandCenter:execute("1105","狮驼岭",cc.pos(40,30),true) then
		skynet.error("寻路大大王失败")
		return false
	end

	if not CommandCenter:execute("1101","大大王",true) then
		skynet.error("对话大大王失败")
		return false
	end

	while true do
		if CommandCenter:execute("1107","zhandou") then
			return true
		end
		skynet.sleep(100)
	end
	
	return true
end

return cmd