local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local super = require("commands.cmd_base")
local cmd = class("cmd_1005",super)

--有一种特殊的情况:
--大地图将小地图覆盖的情况下,前两个就会不准
--但是为了不增加时间复杂度,另外补两个命令。

--打开当前场景的小地图,如果小地图已经打开则不处理
--如果能确定当前小地图就是需要的小地图的话,可以用这个方法(减少耗时)
--耗时1 ~ 4s
--实测 (没有大地图覆盖)小地图打开的情况下为0.03s
--实测 (没有大地图覆盖)小地图没有打开的情况下为1.6 s
--实测 (大地图覆盖) 小地图打开的情况下 0.5s
--实测 (大地图覆盖) 小地图没有打开的情况下 2s
function cmd:execute()
	--检测大地图是否打开,如果打开则关闭
	local bigOpen = self:isBigMapOpen()
	if bigOpen then
		HardWareUtil:KeyPad("alt+2")
	end

	local smallOpen = self:isSmallMapOpen(10) --1s
	if smallOpen then
		return true
	end
	HardWareUtil:KeyPad("alt+1")
	return self:isSmallMapOpen(30) and true or false
end

return cmd