local skynet = require "skynet"
local queue = require "skynet.queue"
require "skynet.manager"
local Bezier = require("Bezier")
local cls = queue()
local command = {}

function command:MoveToBezier(target)
    local pos = game.dmcenter:GetCursorPos()
    local distance = _distance(pos,target)
    local num = distance/10 * 0.5
    local list = Bezier:BezierTo(pos,target,num)
    table.insert(list,target)
    for i,v in ipairs(list) do
        game.dmcenter:MoveTo(v.x,v.y)
        skynet.sleep(1)
    end
end

function command:MoveAndClick(response,pos)
	game.dmcenter:SetWindowState(1)  --激活窗口
    self:MoveToBezier(pos)
	game.dmcenter:LeftClick()
    response(true, true)
end

function command:LeftClick(response)
	game.dmcenter:SetWindowState(1)  --激活窗口
	game.dmcenter:LeftClick()
    response(true, true)
end

function command:KeyPad(response,keygroup)
	game.dmcenter:SetWindowState(1)  --激活窗口
	game.dmcenter:KeyGroup(keygroup)
	response(true,true)
end

function command:DoubleRightClick(response)
	game.dmcenter:SetWindowState(1)  --激活窗口
	game.dmcenter:RightClick()
	skynet.sleep(1)
	game.dmcenter:RightClick()
	response(true,true)
end

function command:MoveToRightClick(response,pos)
	game.dmcenter:SetWindowState(1)  --激活窗口
	self:MoveToBezier(pos)
	game.dmcenter:RightClick()
	response(true,true)
end

function command:SendGBKString(response,text)
	game.dmcenter:SetWindowState(1)  --激活窗口
	for i=1,10 do
		game.dmcenter:KeyPressChar("back")
	end
 
	game.dmcenter:SendGBKString(text)
	response(true,true)
end

function command:MoveTo(response,pos)
	game.dmcenter:SetWindowState(1)  --激活窗口
	self:MoveToBezier(pos)
	response(true,true)
end

function command:InitDM(cmd, dm, hwnd, ...)
	local func = assert(command[cmd])
	game.dmcenter:Init(dm, hwnd)
	local response = skynet.response()
	cls(handler(self, func),response, ...)
end

skynet.start(function()
	skynet.dispatch("lua", function(session , source, cmd,dm,hwnd, ...)
		cls(handler(command, command.InitDM), cmd, dm, hwnd, ...)
	end)
	game = {}
	game.dmcenter = require "DMCenter"
	skynet.register ".hardware"
end)
