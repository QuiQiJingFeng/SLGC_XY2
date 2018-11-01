local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)


--打开大地图 并确认大地图打开之后返回
--1、检测小地图是否打开,如果打开则关闭
--2、检测大地图是否打开,如果打开则返回成功
--3、如果大地图没有打开，则打开大地图,并等待完全打开后返回
function cmd:Execute()
	local smallOpen = self:IsSmallMapOpen()
	if smallOpen then
		HardWareUtil:KeyPad("alt+1")
	end
	local bigOpen = self:IsBigMapOpen()
	if bigOpen then
		return true
	end
	HardWareUtil:KeyPad("alt+2")
	return self:IsBigMapOpen(100)
end

return cmd