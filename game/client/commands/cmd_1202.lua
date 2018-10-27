local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local Constants = require("common/Constants")
local super = require("commands.cmd_base")
local cmd = class("cmd_1202",super)

--执行职业任务
function cmd:execute()
	local str = self:parseTask("职业任务")
	if not str then
		skynet.error("cmd_20002 == ERROR_01")
		return
	end

	local result = false
	if string.find(str,"勾魂马面") then
		result = CommandCenter:execute("1203")
	elseif string.find(str,"鬼族使者") then
		result = CommandCenter:execute("1204")
	elseif string.find(str,"人族使者") then
		result = CommandCenter:execute("1205")
	elseif string.find(str,"袁天罡") then
		result = CommandCenter:execute("1206")
	elseif string.find(str,"道士") then
		result = CommandCenter:execute("1207")
	elseif string.find(str,"李世民") then
		result = CommandCenter:execute("1208")
	elseif string.find(str,"信使") then
		result = CommandCenter:execute("1209")
	elseif string.find(str,"孙悟空") then
		result = CommandCenter:execute("1210")
	elseif string.find(str,"大大王") then
		result = CommandCenter:execute("1211")
	else
		skynet.error("cmd_20002 == ERROR_02")
	end

	return result
end



return cmd