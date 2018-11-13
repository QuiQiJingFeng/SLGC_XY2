local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)

function cmd:Execute()
    game.map:GoRoomScene("狮子洞","大大王")
    game.cmdcenterExecute("battle","FIGHT")
end

--[[
--大大王任务
function cmd:Execute()
    if not CommandCenterExecute("1105","狮驼岭",_p(40,30),true) then
        skynet.error("寻路大大王失败")
        return false
    end

    if not CommandCenterExecute("1101","大大王",true) then
        skynet.error("对话大大王失败")
        return false
    end

    while true do
        if CommandCenterExecute("1107","zhandou") then
            return true
        end
        skynet.sleep(100)
    end
    
    return true
end

]]


return cmd