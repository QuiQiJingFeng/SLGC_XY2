local skynet = require("skynet")
local CommandCenter = {}

function CommandCenterExecute(cmd,...)
	if type(cmd) == "number" then
		assert(false,"MUST BE STRING")
	end
	local command = require("commands.cmd_"..cmd).new()
	local time1 = skynet.time()
	game.log.infof("命令[%s]执行中", cmd)
	local finish = commandExecute(...)
	if not finish then
		game.log.warningf("命令[%s]执行失败,服务即将退出",cmd)
		game.log.error("堆栈信息")
		skynet.exit()
	else
		local time2 = skynet.time()
		game.log.info(string.format("cmd_%s 耗时[%.1f]秒",cmd,time2-time1))
    end
    return finish
end

function CommandCenter:TestExecute(cmd,...)
	if type(cmd) == "number" then
		assert(false, "MUST BE STRING")
	end
	local command = require("commands.cmd_" .. cmd).new()
	local time1 = skynet.time()
	game.log.infof("条件命令[%s]执行中", cmd)
	local finish = commandExecute(...)
	if not finish then
		game.log.infof("条件命令[%s]执行失败", cmd)
	else
		local time2 = skynet.time()
		game.log.infof("cmd_%s 耗时[%.1f]秒", cmd, time2 - time1)
	end
	return finish
end

function CommandCenter:Start()
    -- game.cmdcenterExecute("auto_move","地府",_p(80,50),true)
    -- game.map:GoTo("地府",_p(74,54))
    game.map:GoRoomScene("药店","药店老板")
end


return CommandCenter