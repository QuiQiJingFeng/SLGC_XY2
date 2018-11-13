local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)

function cmd:execute()
    
end


--[[

--道士任务
function cmd:Execute()
    -- --寻路道士
    game.cmdcenter:Execute("1105", "方寸山", _p(30, 10))
    --对话道士
    game.cmdcenter:Execute("1106", _p(35, 13))
    --到地狱迷宫一层
    game.cmdcenter:Execute("1105", "地狱迷宫一层", _p(20, 7))
    if self:process() then
        game.cmdcenter:Execute("1105", "方寸山", _p(30, 10))
        game.cmdcenter:Execute("1106", _p(35, 13))
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
        game.cmdcenter:Execute("1103", table.unpack(list[idx]))
        local finish = self:WaitMoveEnd()
        if not finish then
            if game.cmdcenter:TestExecute("1107", "buzhuo", "野鬼|幽灵") then
                local text = self:parseTask("职业任务")
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