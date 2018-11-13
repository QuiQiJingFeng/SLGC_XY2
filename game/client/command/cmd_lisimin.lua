local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)

function cmd:Execute()
    --[[
        game.map:GoRoomScene("金銮殿","李世民")
        game.map:GoTo("斧头帮",_p(50, 50),true,true)
        if self:process() then
            game.map:GoRoomScene("金銮殿","李世民")
            return true
        end
        return
    ]]
end

function cmd:process()
    -- local list = {
    --      _p(30, 100),
    --      _p(100, 30)
    -- }
    -- local index = 1
    -- while true do
    --     if index == 3 then
    --         index = 1
    --     end
    --     local pos = list[index]
    --     local x = pos.x + math.random(1,5)
    --     local y = pos.y + math.random(1,5)
    --     game.map:GoTo("斧头帮",_p(x,y),true)
    --     local ret = self:WaitMoveEnd("FIGHT")
    --     --检测是否移动停止,停止则返回
    --     if ret == "FIGHT" then
    --         local text = self:ParseTask("职业任务")
    --         if string.find(text, "李世民") then
    --             return true
    --         end
    --     else
    --         index = index + 1
    --     end
    -- end
end
--[[

--李世民任务
function cmd:Execute()
    self:GoToWithYellow("皇宫",_p(126, 50),nil,"李世民",_p(68,40))
    skynet.sleep(50)

    --打开斧头帮的小地图
    game.cmdcenterExecute("0009","斧头帮",_p(50, 50),false)
    --1、检测飞行棋
    if not self:CheckFlyFlag("斧头帮", _p(50, 50),"big") then
        --寻路到斧头帮
        game.cmdcenterExecute("0012","斧头帮",_p(156, 147), true)
    end
    --检测是否移动停止,停止则返回
    game.cmdcenterExecute("0001","FIGHT")

    if self:process() then
        self:GoToWithYellow("皇宫",_p(126, 50),nil,"李世民",_p(68,40))
    end

    return true
end

function cmd:ChatLiShiMin()
    --打开皇宫的小地图
    -- game.cmdcenterExecute("0009","皇宫",_p(126, 50),false)
    -- --1、飞检测黄色飞行棋
    -- if not self:CheckFlyFlag("皇宫", _p(126, 50),"big",true) then
    --     --如果没有黄色的飞行棋,则检测蓝色的飞行棋
    --     if not self:CheckFlyFlag("皇宫", _p(126, 50),"big") then
    --         --寻路到皇宫
    --         game.cmdcenterExecute("0012","皇宫",_p(156, 147), true)
    --         game.cmdcenter:TestExecute("0010","李世民")
    --         --检测是否移动停止,停止则返回
    --         game.cmdcenterExecute("0001","FIGHT")
    --     end
    -- else
    --     game.cmdcenterExecute("0013",_p(68,40))
    -- end
    self:GoToWithYellow("皇宫",_p(126, 50),nil,"李世民",_p(68,40))
end

function cmd:process()
    local list = {
         _p(30, 100),
         _p(100, 30)
    }
    local index = 1
    while true do
        if index == 3 then
            index = 1
        end
        local pos = list[index]
        local x = pos.x + math.random(1,5)
        local y = pos.y + math.random(1,5)
        game.map:GoTo("斧头帮",_p(x,y),true)
        local ret = self:WaitMoveEnd("FIGHT")
        --检测是否移动停止,停止则返回
        if ret == "FIGHT" then
            local text = self:ParseTask("职业任务")
            if string.find(text, "李世民") then
                return true
            end
        else
            index = index + 1
        end
    end
end
]]

return cmd