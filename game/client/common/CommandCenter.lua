local skynet = require("skynet")
local CommandCenter = {}

function CommandCenter:execute(cmd,...)
	if type(cmd) == "number" then
		assert(false,"MUST BE STRING")
	end
	local command = require("commands.cmd_"..cmd).new()
	local time1 = skynet.time()
	local finish,r1,r2,r3,r4 = command:execute(...)
	if not finish then
		-- local msg = debug.traceback("cmd excute faild "..cmd)
		-- skynet.error(msg)
		skynet.error("cmd failed = ",cmd)
	else
		local time2 = skynet.time()
		skynet.error(string.format("cmd_%s 耗时%f",cmd,time2-time1))
	end
	
	return finish,r1,r2,r3,r4
end

return CommandCenter