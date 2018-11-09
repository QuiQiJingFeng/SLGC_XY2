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









return cmd