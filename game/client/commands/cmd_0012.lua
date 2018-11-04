local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)


--自动寻路=>移动到指定场景的指定坐标
function cmd:Start(sceneName, coordPos, stopArea)
    local data = self:GetCurAreaAndPosWithCapther()
    if not data then
        return
    end
    self:FlyUp()
    while true do
        for i=1,1 do
            local data = self:GetCurAreaAndPosWithCapther()
            if not data then
                return
            end
            --如果相同那么执行小地图移动
            if string.find(data.name,sceneName)  then
                if stopArea then
                    return true
                end
                local distance = _distance(coordPos,data)
                if distance <= 10 then
                    return true
                end
                --打开小地图并点击指定的坐标
                game.cmdcenter:Execute("0011",sceneName, coordPos)
            else
                --打开大地图并点击指定的坐标
                game.cmdcenter:Execute("0009",sceneName,coordPos)
            end
            --等待移动停止，如果中途遇敌的话 直接逃跑
            local ret = game.cmdcenter:Execute("0001","ESCAPE")
            if ret == "FIGHT" then
                --如果是因为战斗而停止移动的,返回最上面继续执行一遍
                break
            end

            local tempdata = self:GetCurAreaAndPosWithCapther()
            if not tempdata then
                return
            end
            --如果相同那么执行小地图移动
            if string.find(tempdata.name,sceneName) then
                if stopArea then
                    return true
                end
                local distance = _distance(coordPos,tempdata)
                if distance <= 10 then
                    return true
                end
            end
            HardWareUtil:MoveTo(_p(750,math.random(10,60)))
            --检测黄色提示标志
            if game.cmdcenter:TestExecute("0003") then
                --点击了黄色标志之后
                skynet.sleep(30)
                local newData
                local finish = false
                for i=1,30 do
                    newData = self:GetCurAreaAndPosWithCapther()
                    if not newData then
                        return
                    end
                    --确认场景跳转完成之后跳出循环
                    if newData.name ~= data.name then
                        finish = true
                        break
                    end
                    skynet.sleep(10)
                end
                if not finish then
                    game.log.error("3秒都没有跳转完成,估计是网络掉线了")
                    return
                end
                --跳转完成之后重新走一遍上面的流程
                break
            else
                break
            end
        end
    end
end

function cmd:Execute(sceneName, coordPos, stopArea)
    local finish = self:Start(sceneName,coordPos,stopArea)
    if finish then
        self:FlyDown()
    end
    game.cmdcenter:Execute("0006")
    return finish
end

return cmd
