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
    if not game.cmdcenter:TestExecute("0002", self.__errorType) then
        local path = self:Capture(0, 0, 150, 30)
        game.log.errorf("获取当前场景的名称、坐标失败,截图存放在[%s]",path)
        return
    else
        return true --战斗处理完成
    end
end

function cmd:WaitMoveEnd(callback)
    local prePos = _p(0, 0)
    while true do
        local pos = self:GetCurAreaAndPos()
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