local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local super = require("commands.cmd_base")
local cmd = class("cmd_1004",super)

--注:大地图将小地图覆盖的情况无法解决,请使用10022
--打开当前场景的小地图,如果小地图已经打开则不处理
--如果能确定当前小地图就是需要的小地图的话,可以用这个方法(减少耗时)
--耗时0 ~ 3.1s
--实测 小地图打开的情况下为0.03s
--实测 小地图没有打开的情况下为0.5
function cmd:execute()
	local smallOpen = self:isSmallMapOpen(5) --0s
	if smallOpen then
		return true
	end
	HardWareUtil:KeyPad("alt+1")
	return self:isSmallMapOpen(30) and true or false
end

return cmd