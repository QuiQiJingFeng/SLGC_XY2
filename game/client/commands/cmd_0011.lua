local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)


--打开小地图并 点击指定坐标
function cmd:Execute(name,coordPos)
	game.cmdcenter:Execute("0005")
    local pixelPos = self:ConvertToWordSpace(name, coordPos)
	if not pixelPos then
		game.log.warningf("转换坐标到屏幕坐标失败 地区[%s]", name)
		return
	end
	HardWareUtil:MoveAndClick(pixelPos)

    return true
end
 

return cmd