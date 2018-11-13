local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)

function cmd:Execute()
    game.map:GoTo("方寸山",_p(35, 13),false,true)
    game.map:ChatPos(_p(35, 13))

    game.map:GoTo("地狱迷宫一层",_p(20, 7),true,true)
    if self:Process() then
        game.map:GoTo("方寸山",_p(35, 13),false,true)
        game.map:ChatPos(_p(35, 13))
        return true
    end
end

function cmd:process()
    local list = {
        {"地狱迷宫一层", _p(40, 20)},
        {"地狱迷宫一层", _p(16, 16)}
    }
 
    local idx = 1
    while true do
        game.map:GoTo(list[idx][1],list[idx][2],true,false)
        local ret = self:WaitMoveEnd("CATCH")
        if ret == "FIGHT" then
            local text = self:ParseTask("职业任务")
            if string.find(text, "道士") then
                return true
            end
        end
        idx = idx + 1
        if idx == 3 then
            idx = 1
        end
    end
end

--[[

--道士任务
function cmd:Execute()
    -- --寻路道士
    game.cmdcenterExecute("1105", "方寸山", _p(30, 10))
    --对话道士
    game.cmdcenterExecute("1106", _p(35, 13))
    --到地狱迷宫一层
    game.cmdcenterExecute("1105", "地狱迷宫一层", _p(20, 7))
    if self:process() then
        game.cmdcenterExecute("1105", "方寸山", _p(30, 10))
        game.cmdcenterExecute("1106", _p(35, 13))
        return true
    end
    
end

function cmd:process()
    local list = {
        {"地狱迷宫一层", _p(40, 20)},
        {"地狱迷宫一层", _p(16, 16)}
    }
    self:SetForbidFlyFlag(true)
    local idx = 1
    while true do
        game.cmdcenterExecute("1103", table.unpack(list[idx]))
        local finish = self:WaitMoveEnd()
        if not finish then
            if game.cmdcenter:TestExecute("1107", "buzhuo", "野鬼|幽灵") then
                local text = self:ParseTask("职业任务")
                if string.find(text, "道士") then
                    self:SetForbidFlyFlag(false)
                    return true
                end
            end
        end
        idx = idx + 1
        if idx == 3 then
            idx = 1
        end
    end
end
]]

return cmd