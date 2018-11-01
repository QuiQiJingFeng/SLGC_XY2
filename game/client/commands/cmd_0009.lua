local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)

--通过大地图打开小地图并 点击指定坐标
function cmd:Execute(name,coordPos)
    --打开大地图 并确认大地图打开之后返回
    game.cmdcenter:Execute("0004")
    local data = game.data:GetBigMapByName(name)
	local x = data.x + math.random(0,data.dx)
    local y = data.y + math.random(0,data.dy)
	HardWareUtil:MoveAndClick(_p(x, y))
 	--检测小地图是否打开
	if not self:IsSmallMapOpen(10) then
		game.log.warning("没有检测到小地图打开")
		return
	end
	local pixelPos = self:ConvertToWordSpace(name, coordPos, "big")
	if not pixelPos then
		game.log.warningf("转换坐标到屏幕坐标失败 地区[%s]", name)
		return
    end
    
    HardWareUtil:MoveAndClick(pixelPos)
    return true
end



 
return cmd