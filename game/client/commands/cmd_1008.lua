local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")
local super = require("commands.cmd_base")
local cmd = class("cmd_1008",super)

--关闭任务栏界面
function cmd:execute()
	local pos = self:repeatFind(1,0,0,800,600,"resource/19.bmp","020202",1,0)
	if pos then
		HardWareUtil:KeyPad("alt+q")
	end
  	skynet.sleep(50)
	return true
end

return cmd