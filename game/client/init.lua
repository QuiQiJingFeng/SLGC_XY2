local skynet = require "skynet"
local core = require "skynet.core"

local command = {}

function command:Start(hwnd)
  	local dm = game.dmcenter:createDM()
  	game.dmcenter:Init(dm,hwnd)
	local code = game.dmcenter:Reg("jingfeng7e36df561a35a1619b46fc0b24fb738a","")
    if code ~= 1 then
        game.log.errorf("收费功能注册失败:错误码为[%s]",game.dmcenter:GetLastError())
    end
	local path = game.dmcenter:GetBasePath()
	assert(game.dmcenter:SetPath(path.."/res"),"设置搜索路径失败")
	--TODO 之后要设置成后台读取的
	--前台模式,一旦遮挡就无法 搜索
	--local success = DMCenter:BindWindow(dm,hwnd,"normal","normal","normal",101)
	--后台模式,遮挡的情况下也可以获取到刷新
	--注意: 如果键盘、鼠标设置成dx模式的话, 前台鼠标就无法手动操作了
	local conf = {"dx2","normal","normal","",0}
	local success = game.dmcenter:BindWindowEx(table.unpack(conf))
	if not success then
		game.log.errorf("绑定窗口失败:错误码为[%s]",game.dmcenter:GetLastError())
		return 
	end
	game.dmcenter:EnableKeypadPatch(true)
	assert(game.dmcenter:EnableMouseSync(true,300),"鼠标同步设置失败")
	assert(game.dmcenter:EnableKeypadSync(true,300),"键盘同步失败")

    game.dmcenter:SetWordGap(10)
    
    --记录服务的数据到文件
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))


    game.log = require "log"
    game.csv = require "CSVLoder"
    game.data = require "DataManager"
    game.dict = require "DictManager"
    game.cmdcenter = require "CommandCenter"
    game.bag = require "BagManager"
    game.item = require "ItemManager"
    game.tip = require "TipManager"
    game.map = require "MapManager"
	game.cmdcenter:Start()
end

skynet.start(function()
	skynet.dispatch("lua", function(session , source, cmd, ...)
		local f = assert(command[cmd])
		f(command,...)
	end)
    game = {}
    game.dmcenter = require "DMCenter"
end)
