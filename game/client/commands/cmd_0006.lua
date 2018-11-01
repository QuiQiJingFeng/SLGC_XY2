local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)



--关闭所有的地图 等待完全关闭后返回
--1、检测大地图是否打开,如果打开则关闭
--2、检测小地图是否打开,如果打开则关闭
function cmd:Execute()
	local smallClose = false
	local smallOpen = self:IsSmallMapOpen()
	if smallOpen then
		HardWareUtil:KeyPad("alt+1")
		smallClose = true
	end

	local bigOpen = self:IsBigMapOpen()
	if bigOpen then
		HardWareUtil:KeyPad("alt+2")
	end

	
	if not smallClose then
		local smallOpen = self:IsSmallMapOpen(10)
		if smallOpen then
			HardWareUtil:KeyPad("alt+1")
		end
	end
	for i=1,10 do
		smallOpen = self:IsSmallMapOpen()
		if not smallOpen then
			break
		end
		skynet.sleep(10)
	end
	return true
end

return cmd