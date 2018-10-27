local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local super = require("commands.cmd_base")
local cmd = class("cmd_1209",super)

--信使任务
function cmd:execute()
	return true
end

return cmd