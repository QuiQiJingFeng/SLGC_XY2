local skynet = require "skynet"
local queue = require "skynet.queue"
require "skynet.manager"
local cls = queue()
local command = {}

function command:MoveAndClick(response,pos)
	DMCenter:SetWindowState(1)  --激活窗口
    DMCenter:MoveTo(pos.x,pos.y)
    skynet.sleep(1)
	DMCenter:LeftClick()
    response(true, true)
end

function command:LeftClick(response)
	DMCenter:SetWindowState(1)  --激活窗口
	DMCenter:LeftClick()
    response(true, true)
end

function command:KeyPad(response,keygroup)
	DMCenter:SetWindowState(1)  --激活窗口
	DMCenter:KeyGroup(keygroup)
	response(true,true)
end

function command:DoubleRightClick(response)
	DMCenter:SetWindowState(1)  --激活窗口
	DMCenter:RightClick()
	skynet.sleep(1)
	DMCenter:RightClick()
	response(true,true)
end

function command:MoveToRightClick(response,pos)
	DMCenter:SetWindowState(1)  --激活窗口
	DMCenter:MoveTo(pos.x,pos.y)
    skynet.sleep(1)
	DMCenter:RightClick()
	response(true,true)
end

function command:SendGBKString(response,text)
	DMCenter:SetWindowState(1)  --激活窗口
	for i=1,10 do
		DMCenter:KeyPressChar("back")
	end
 
	DMCenter:SendGBKString(text)
	response(true,true)
end

function command:MoveTo(response,x,y)
	DMCenter:SetWindowState(1)  --激活窗口
	DMCenter:MoveTo(x,y)
	response(true,true)
end

function command:InitDM(cmd, dm, hwnd, ...)
	local func = assert(command[cmd])
	DMCenter:Init(dm, hwnd)
	local response = skynet.response()
	cls(handler(self, func),response, ...)
end

skynet.start(function()
	skynet.dispatch("lua", function(session , source, cmd,dm,hwnd, ...)
		cls(handler(command, command.InitDM), cmd, dm, hwnd, ...)
	end)
	require "functions"
	DMCenter = require "DMCenter"
	skynet.register ".hardware"
end)
