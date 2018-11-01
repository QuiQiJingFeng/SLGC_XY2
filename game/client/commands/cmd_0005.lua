local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)

--关闭所有打开的地图，并打开当前场景的小地图
--打开小地图
function cmd:Execute()
	game.cmdcenter:Execute("0006")
	HardWareUtil:KeyPad("alt+1")
	return self:IsSmallMapOpen(100) and true or false
end

return cmd