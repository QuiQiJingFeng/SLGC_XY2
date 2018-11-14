local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)

function cmd:Execute()
    
end

--[[
local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)


--孙悟空任务
function cmd:Execute()

    self:GoTo("龙窟七层",_p(30, 54))
    --对话孙悟空
    game.cmdcenterExecute("0013",_p(30, 54))
    skynet.sleep(100)
    local text = self:ParseTask("职业任务","ff0000-000000")
    local iter = string.gmatch(text, "(.-)%(1%)")
    local name = iter()
    local iter = string.gmatch(text, "(%d+)")
    local num = tonumber(iter())
    --买药啊
    game.cmdcenterExecute("0015",name,num)
    --去傲来国
    self:GoTo("傲来国", _p(311, 35))
    --对话紫霞
    game.cmdcenterExecute("0013",_p(311, 35))
    skynet.sleep(100)
    return self:searchAndClickText("00d011-000000", "病")
end

return cmd
]]


return cmd