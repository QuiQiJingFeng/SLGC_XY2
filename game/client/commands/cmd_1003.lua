local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local super = require("commands.cmd_base")
local cmd = class("cmd_1003",super)

--注:大地图将小地图覆盖的情况无法解决,请使用10023
--打开当前场景的小地图
--会检测当前是否已经有打开的小地图,如果有则关闭
--耗时0 ~ 3.1s
--实测 小地图打开的情况下为1s
--实测 小地图没有打开的情况下为0.5
function cmd:execute()
	local smallOpen = self:isSmallMapOpen() --0s
	if smallOpen then
		HardWareUtil:KeyPad("alt+1")
	end
	
	HardWareUtil:KeyPad("alt+1")
	return self:isSmallMapOpen(30) and true or false
end

return cmd