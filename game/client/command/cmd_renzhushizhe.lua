local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)

function cmd:Execute()
    --[[
        game.map:GoTo("长安",_p(383, 12),false,true)
        game.map:ChatPos(_p(383, 12))
        skynet.sleep(100)
        local list = {
                {name = "大唐边境",pos = _p(170,222)},
                {name = "北俱芦洲",pos = _p(120,80)},
                {name = "海底迷宫三层",pos = _p(40,20)}
            }
        for i,v in ipairs(list) do
            self:goGetYaoCai(v)
        end
        game.map:GoTo("长安",_p(383, 12),false,true)
        game.map:ChatPos(_p(383, 12))
        return true
    ]]
end


--[[

function cmd:ChatRenZhuShizhe()
    self:GoTo("长安", _p(383, 12))
    --对话人族使者
    game.cmdcenterExecute("0013", _p(383, 12))
end

--人族使者任务
function cmd:Execute()
    self:ChatRenZhuShizhe()
    skynet.sleep(100)
    local list = {
            {name = "大唐边境",pos = _p(170,222)},
            {name = "北俱芦洲",pos = _p(120,80)},
            {name = "海底迷宫三层",pos = _p(40,20)}
        }
    for i,v in ipairs(list) do
        self:goGetYaoCai(v)
    end
    self:ChatRenZhuShizhe()

    return true
end

function cmd:goGetYaoCai(conf)
    local areaName = conf.name
    local pos = conf.pos
    self:GoTo(areaName,pos,true,true)
    local data = game.map:GetCurAreaAndPos()
    local x ,y
    while true do
        local zf = math.random(0,1) > 0.5 and 1 or -1
        x = data.x + math.random(10,20) * zf
        y = data.y + math.random(10,20) * zf
        game.map:GoTo(data.name,_p(x,y),true)
        local ret = self:WaitMoveEnd("CATCH")
        if ret == "FIGHT" then
            if self:checkIsHasYaoCai() then
                skynet.error("找到药材")
                return true
            end
        end
    end
end

function cmd:checkIsHasYaoCai()
    game.dict:ChangeDict("ST_11")
    local text = game.dmcenter:Ocr(96, 127, 587+96, 362+127,"00ff00-000000",1)
    if string.find(text,"药材") then
        return true
    end
end
]]

return cmd