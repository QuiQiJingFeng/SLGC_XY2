local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)

--洛阳购买指定的药品
function cmd:Execute(name,num)
    game.cmdcenter:Execute("1102", "洛阳城", _p(156, 147), true, true)
    if self:CheckFlyFlag("洛阳城", _p(140, 60), false, true,{x1=250,y1=195,x2=323,y2=279}) then
        skynet.sleep(30)
        game.cmdcenter:Execute("1106", _p(14, 12))
    else
        game.cmdcenter:Execute("1105", "洛阳城", _p(156, 147), true)
        game.cmdcenter:Execute("1101", "药店老板")
    end

    local success = false
    for i=1,30 do
        success = self:searchAndClickText("00d011-000000", "买点东西")
        if success then
            break
        end
        skynet.sleep(10)
    end
    if not success then
        game.warning("没有找到买东西的对话")
        return
    end
    local newname = game.dmcenter:UTF8ToGBK(name)

    local path = "items/"..newname..".bmp"
    local pos = self:RepeatFind(10, 0, 0, 800, 600, path, "020202", 1, 0)
    if not pos then
        game.log.warningf("没有找到对应的药品[%s]",name)
        return
    end
    for i=1,num do
       HardWareUtil:MoveAndClick(pos)
       skynet.sleep(math.ceil(1,5))
    end
    local path = "goumai.bmp"
    local pos = self:RepeatFind(10, 0, 0, 800, 600, path, "020202", 1, 0)
    if not pos then
        game.log.warning("洛阳药店找不到购买按钮")
        return
    end
    HardWareUtil:MoveAndClick(pos)
    skynet.sleep(20)
    return true
end
return cmd
