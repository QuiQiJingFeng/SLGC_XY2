local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)


--关闭任务栏界面
function cmd:Execute()
	local pos = self:RepeatFind(1,0,0,800,600,"19.bmp","020202",1,0)
	if pos then
		HardWareUtil:KeyPad("alt+q")
	else
		return true
	end

	while true do
		local pos = self:RepeatFind(1, 0, 0, 800, 600, "19.bmp", "020202", 1, 0)
		if not pos then
			return true
		end
		skynet.sleep(10)
	end
end

return cmd