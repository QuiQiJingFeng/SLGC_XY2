local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)

function cmd:Execute(errorType)
    self.__errorType = errorType or "ESCAPE"
    --等待移动停止
    game.log.info("移动中")
    local ret = self:WaitMoveEnd()
    game.log.info("移动停止")
    return ret
end

function cmd:ErrorProcess()
    --错误处理函数
    --无法获取场景名称的情况有两种
    --1、进入战斗的时候不会显示
    --2、当被遮挡的时候会有问题
    --先检测是否是战斗导致的,如果是则处理战斗,战斗参数设置为逃跑
    game.log.info("获取场景名称失败,尝试进入战斗")
    if not game.cmdcenter:TestExecute("battle", self.__errorType) then
        game.log.error("进入战斗失败,遇到未知的情况")
    else
        return true --战斗处理完成
    end
end

function cmd:WaitMoveEnd(callback)
    local prePos = _p(0, 0)
    while true do
        local pos = game.map:GetCurAreaAndPos()
        if not pos then
            return self:ErrorProcess() and "FIGHT" or nil
        end
        local dist = _distance(prePos, pos)
        if dist == 0 then
            return "MOVE_END"
        end
        prePos = pos
        skynet.sleep(100)
    end
end





return cmd