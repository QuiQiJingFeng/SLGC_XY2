local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)

function cmd:execute()
    
end

--[[
--获取指定题目的答案
function cmd:Execute(text)
     HardWareUtil:KeyPad("alt+f")
     skynet.sleep(100)
     HardWareUtil:MoveAndClick(_p(700,135))
     skynet.sleep(100)
     HardWareUtil:SendGBKString(text)
     HardWareUtil:KeyPad("enter")
     skynet.sleep(100)
     HardWareUtil:MoveTo(_p(0,0))
     HardWareUtil:KeyPad("alt+f")
     game.dmcenter:UseDict(3)
    skynet.sleep(100)
    HardWareUtil:KeyPad("alt+f")
    game.dmcenter:SetWordGap(10)
    local list = game.dmcenter:GetWordsNew(150,100,600,500,"ffffff-000000",1)
    HardWareUtil:MoveToRightClick(_p(520,130))
    game.dmcenter:SetWordGap(5)
    for idx,value in ipairs(list) do
        if string.find(value.word,text) then
            return list[idx + 1].word
        end
    end
    return false
end

]]


return cmd