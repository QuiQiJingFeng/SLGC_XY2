local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)


--查找黄色提示文字并点击
function cmd:Execute()
    game.dict:ChangeDict("ST_B_11")
	local list
	for i=1,5 do
		list = game.dmcenter:GetWordsNew(135,200,362,415, "ffff00-000000", 1.0)
		if #list > 0 then
			break
		end
	end

	if #list <= 0 then
		game.log.info("没有找到黄色提示")
		return
    end
    
    --找到黄色提示之后 还要判断下是否是有效的地址
    game.log.infof("查找到黄色提示路标[%s]",list[1].word)
    local area = list[1].word
    local check = game.data:CheckInvalidAreaName(area)
    if not check then
        game.log.warning("黄色提示无效")
        return
    end

	local obj = list[1]
	obj.pos.x = obj.pos.x + math.random(10,50)
	obj.pos.y = obj.pos.y + math.random(3,8)
	HardWareUtil:MoveAndClick(obj.pos)
    return true
end
 

return cmd