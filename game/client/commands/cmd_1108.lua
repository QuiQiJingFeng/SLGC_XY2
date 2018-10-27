local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local super = require("commands.cmd_base")
local cmd = class("cmd_1108",super)

--获取指定题目的答案
function cmd:execute(text)
	 HardWareUtil:KeyPad("alt+f")
	 skynet.sleep(100)
	 HardWareUtil:MoveAndClick(cc.pos(700,135))
	 skynet.sleep(100)
	 HardWareUtil:SendGBKString(text)
	 HardWareUtil:KeyPad("enter")
	 skynet.sleep(100)
	 HardWareUtil:MoveTo(600,100)
	 skynet.sleep(10)
	 HardWareUtil:KeyPad("alt+f")
	 if not DMCenter:UseDict(3) then
		skynet.error("UseDict Failed")
		return
	end
	HardWareUtil:KeyPad("alt+f")
	local list = DMCenter:GetWordsNew(150,200,600,400,"ffffff-000000",1)
	HardWareUtil:MoveToRightClick(cc.pos(520,130))
	for idx,value in ipairs(list) do
		if string.find(value.word,text) then
			return list[idx + 1].word
		end
	end
	return false
end
return cmd