local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)

function cmd:execute()
    
end

--[[
--大大王任务
function cmd:Execute()
    if not CommandCenter:Execute("1105","狮驼岭",_p(40,30),true) then
        skynet.error("寻路大大王失败")
        return false
    end

    if not CommandCenter:Execute("1101","大大王",true) then
        skynet.error("对话大大王失败")
        return false
    end

    while true do
        if CommandCenter:Execute("1107","zhandou") then
            return true
        end
        skynet.sleep(100)
    end
    
    return true
end

]]


return cmd