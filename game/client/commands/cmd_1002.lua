local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local super = require("commands.cmd_base")
local cmd = class("cmd_1002",super)

--关闭所有的地图 等待完全关闭后返回
--实测耗时
function cmd:execute()
	local bigOpen = self:isBigMapOpen()
	if bigOpen then
		HardWareUtil:KeyPad("alt+2")
	end

	local smallOpen = self:isSmallMapOpen(10)
	if smallOpen then
		HardWareUtil:KeyPad("alt+1")
	end
	for i=1,10 do
		smallOpen = self:isSmallMapOpen()
		if not smallOpen then
			break
		end
		skynet.sleep(10)
	end
	return true
end

return cmd