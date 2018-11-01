local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)

--打开任务栏界面
--1、如果已经打开则直接返回
--2、如果没有打开,则使用alt+q打开,如果发现alt+q打不开,则重新alt+q一次
function cmd:Execute()
	local pos = self:RepeatFind(1,0,0,800,600,"19.bmp","020202",1,0)
	if pos then
		return true
	end
	--为了加速查询时间,假设它没有打开面板
	--用1s的时间去打开任务面板并检测
	for i=1,2 do
		HardWareUtil:KeyPad("alt+q")
		local pos = self:RepeatFind(10, 0, 0, 800, 600, "19.bmp", "020202", 1, 0)
		if pos then
			return true
		end
	end
end

	return cmd