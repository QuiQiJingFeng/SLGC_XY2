local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)

function cmd:Execute()
    
end


--[[

--勾魂马面任务
function cmd:Execute()
    --1、前往轮回司
    self:GoTo("轮回司", _p(58, 28))
    
    --2、对话话勾魂使者
    game.cmdcenterExecute("0013",_p(57, 33))
    skynet.sleep(100)
    --获取任务描述
    local npcName = self:ParseTask("职业任务")
    game.log.infof("NPC->[%s]",npcName)
    local select =  game.data:GetNPCMapByName(npcName)
    if not select then
        game.log.warningf("NPC [%s]配置不存在", npcName)
        return
    end
    game.cmdcenterExecute("0012",select.area,_p(select.x + 3, select.y + 3),true)
    
    --小红点找人
    game.cmdcenter:TestExecute("0010",npcName)

    --检测是否移动停止,停止则返回
    game.cmdcenterExecute("0001","FIGHT")

    local find = false
    for i=1,30 do
        find = self:searchAndClickText("00d011-101010","伏羲琴")
        if find then
            break
        end
        skynet.sleep(10)
    end
    if not find then
        game.log.warning("使用伏羲琴失败")
        return
    end

    return true
end
]]

return cmd