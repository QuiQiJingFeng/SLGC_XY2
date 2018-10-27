local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")
local super = require("commands.cmd_base")
local cmd = class("cmd_1007",super)

--打开任务栏界面
--最坏的情况下,即大地图或小地图盖住了任务面板 2s
function cmd:execute()
	local pos = self:repeatFind(1,0,0,800,600,"resource/19.bmp","020202",1,0)
	if pos then
		return true
	end

	--为了加速查询时间,假设它没有打开面板
	--用1s的时间去打开任务面板并检测
	HardWareUtil:KeyPad("alt+q")
	local pos = self:repeatFind(10,0,0,800,600,"resource/19.bmp","020202",1,0)
	if pos then
		return true
	end

	--如果没有打开,说明被其他东西盖住了,之前的操作将面板关闭了,
	--重新打开就好 这样的话时间会省去很多
	HardWareUtil:KeyPad("alt+q")
	local pos = self:repeatFind(20,0,0,800,600,"resource/19.bmp","020202",1,0)
	if pos then
		return true
	end
	return true
end

return cmd