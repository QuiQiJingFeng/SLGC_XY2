local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local super = require("commands.cmd_base")
local cmd = class("cmd_1001",super)

--打开大地图 并确认大地图打开之后返回
--耗时 0~3s
--实测 大地图打开的情况下为0.02s
--实测 大地图没有打开的情况下为0.48s
function cmd:execute()
	local smallOpen = self:isSmallMapOpen()
	if smallOpen then
		HardWareUtil:KeyPad("alt+1")
	end
	local bigOpen = self:isBigMapOpen()
	if bigOpen then
		return true
	end
	HardWareUtil:KeyPad("alt+2")
	return self:isBigMapOpen(30)
end

return cmd