local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local super = require("commands.cmd_base")
local cmd = class("cmd_1206",super)

--袁天罡任务
function cmd:execute()
	return true
end

return cmd