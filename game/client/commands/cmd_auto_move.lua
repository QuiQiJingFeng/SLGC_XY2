local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)

function cmd:CheckExit(tname,tpos,stopArea)
    local nextLoop = true
    local data = self:GetCurAreaAndPosWithCapther()
    self.__inArea = string.find(tname,data.name) and true or false
    
    skynet.error("tname = ",tname)
    skynet.error("name = ",data.name)
    skynet.error("self.__inArea = ",self.__inArea)

    if self.__inArea and _distance(data,tpos) == 0 then
        nextLoop = false
    elseif self.__inArea and stopArea then
        nextLoop = false
    end
    return nextLoop
end

function cmd:Execute(tname,tpos,stopArea)
    self:WaitMoveEnd()
    local times = 0
    while self:CheckExit(tname,tpos,stopArea) do
        for i=1,1 do
            if self.__inArea then
                times = times + 1
                if times >= 2 then
                    self:FlyUp()
                end
                game.map:OpenCurSmallAndClick(tpos)
            else
                HardWareUtil:MoveTo(_p(400,300))
                skynet.sleep(30)
                if game.tip:CheckYellowArea() then
                    break
                end
                game.map:OpenBigMapToSmallAndClick(tname,tpos)
            end
            self:WaitMoveEnd()
        end
    end
    self:FlyDown()
    return true
end

return cmd


