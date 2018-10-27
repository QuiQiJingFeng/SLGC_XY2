local skynet = require "skynet"

local command = {}
local hash = {} 
local maxValue = 0
local maxKey = ""


function command:Update()
 	local PluginManager = require("manager/PluginManager")
 	PluginManager:Update()
    skynet.timeout(10,handler(self, self.Update))

end

function command:Init()
	math.randomseed(skynet.time())
	require("common.CSVLoder"):Init()
	require("common/MapManager"):Init()
	require("manager/PluginManager"):Init()
end

function command:Start(hwnd)
  	local dm = DMCenter:createDM()
  	DMCenter:Init(dm,hwnd)
	local code = DMCenter:Reg("jingfeng7e36df561a35a1619b46fc0b24fb738a","")
	assert(code == 1,"收费功能注册失败")
	local path = DMCenter:GetBasePath()
	assert(DMCenter:SetPath(path.."/res"),"设置搜索路径失败")

	
	--TODO 之后要设置成后台读取的
	--前台模式,一旦遮挡就无法 搜索
	--local success = DMCenter:BindWindow(dm,hwnd,"normal","normal","normal",101)
	--后台模式,遮挡的情况下也可以获取到刷新
	--注意: 如果键盘、鼠标设置成dx模式的话, 前台鼠标就无法手动操作了
	local conf = {}
	conf[1] = "dx2"
	conf[2] = "normal"
	conf[3] = "normal"
	conf[4] = ""
	conf[5] = 0
	local success = DMCenter:BindWindowEx(table.unpack(conf))
	if not success then
		skynet.error("BindWindowEx FAILED ERROR->",DMCenter:GetLastError())
		return 
	end
	DMCenter:EnableKeypadPatch(true)
	assert(DMCenter:EnableMouseSync(true,300),"鼠标同步设置失败")
	assert(DMCenter:EnableKeypadSync(true,300),"键盘同步失败")
 	self:Init()
	self:Update()
end

skynet.start(function()
	skynet.dispatch("lua", function(session , source, cmd, ...)
		local f = assert(command[cmd])
		f(command,...)
	end)
	require "functions"
	DMCenter = require "DMCenter"
end)
