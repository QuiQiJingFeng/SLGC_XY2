local skynet = require "skynet"

local function Init()
    skynet.newservice("hardware")
    local DMCenter = require("DMCenter")
    local dm = DMCenter:createDM()
    DMCenter:Init(dm)
    local ret = DMCenter:EnumWindow(0,"","WSWINDOW",2+8+16)
    local windows = string.split(ret,",")
    for i,hwnd in ipairs(windows) do
        local client = skynet.newservice("client")
        skynet.send(client,"lua","Start",hwnd)
    end
end

skynet.start(function()
    Init()
    print("Watchdog listen on ", 8888)
    skynet.exit()
end)
