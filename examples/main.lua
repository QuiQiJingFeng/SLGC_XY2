local skynet = require "skynet"
local utils = require "utils"

skynet.start(function()
	
	local DMCenter = require("DMCenter")
	local dm = DMCenter:createDM()
	local ret = DMCenter:EnumWindow(dm,0,"","WSWINDOW",2+8+16)
	local windows = utils:split(ret,",")
 	local services = {}
	for i,hwnd in ipairs(windows) do
 		local client = skynet.newservice("client")
		table.insert(services,client)
		skynet.send(client,"lua","Start",hwnd)
	end
	print("Watchdog listen on ", 8888)


	skynet.exit()
end)
