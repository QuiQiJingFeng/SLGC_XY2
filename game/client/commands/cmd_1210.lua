local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)


--孙悟空任务
function cmd:Execute()
	--寻路孙悟空
	game.cmdcenter:Execute("1105", "龙窟七层", _p(30, 54))
	--对话孙悟空
	game.cmdcenter:TestExecute("1106", _p(30, 54))

	local text = self:parseTask("职业任务","ff0000-000000")
	local iter = string.gmatch(text, "(.-)%(1%)")
	local name = iter()
	local iter = string.gmatch(text, "(%d+)")
	local num = tonumber(iter())
	game.cmdcenter:Execute("1109", name,num)
	--去傲来国
	game.cmdcenter:Execute("1105", "傲来国", _p(311, 35))
	--对话紫霞
	game.cmdcenter:TestExecute("1106", _p(311, 35))
	local success
	for i=1,20 do
		success = self:searchAndClickText("00d011-000000", "病")
		if success then
			break
		end
		skynet.sleep(10)
	end
	return success
end

return cmd