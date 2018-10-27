local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local super = require("commands.cmd_base")
local cmd = class("cmd_1210",super)

--孙悟空任务
function cmd:execute()
	return true
end

return cmd