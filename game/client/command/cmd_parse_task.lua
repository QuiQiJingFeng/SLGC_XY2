local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "command.cmd_base"
local cmd = class("cmd", super)
local TASK_LIST = {
    ["SHUNWUKONG"] = "XXXXX-YYYYY",
    ["DADAWANG"] = "AAAA-XXXXXF",
    ["YUANTIANGANG"] = "CCCC-DDDDD"
}


function cmd:execute()
    local text = self:parseTask("ZYRW")
    for key,value in pairs(TASK_LIST) do
        if string.find(text,value) then
            local cmd = string.lower(key)
            return game.cmdcenter:execute(cmd)
        end
    end
end

--[[

-- --职业任务流程
-- function cmd:Execute()
--  while true do
--      local ret = self:update()
--      if ret == "FINISH" then
--          return true
--      elseif ret == "ERROR" then
--          return false
--      end
--      skynet.error("你褪裙吧!!!")
--      skynet.sleep(100000)
--  end
-- end

-- function cmd:update()
--  local str = self:parseTask("职业任务")
--  if not str then
--      --如果领取任务失败则跳出职业任务流程
--      local ret = CommandCenter:Execute("1201")
--      if ret == "FINISH" then
--          return "FINISH"
--      elseif ret ~= "SUCCESS" then
--          return "ERROR"
--      end
--      skynet.sleep(40)
--      HardWareUtil:MoveTo(_p(600,300))
--      skynet.sleep(10)
--      str = self:parseTask("职业任务")
--  end
--  if not str then
--      skynet.error("FYD--->>>str = ",str)
--      return "ERROR"
--  end
--  local result = self:processTask(str)
--  if not result then
--      skynet.error("任务执行失败=>",str)
--  end
--  return true
-- end

-- function cmd:processTask(str)
--  local result = false
--  if string.find(str,"勾魂马面") then
--      result = CommandCenter:Execute("1203")
--  elseif string.find(str,"鬼族使者") then
--      result = CommandCenter:Execute("1204")
--  elseif string.find(str,"人族使者") then
--      result = CommandCenter:Execute("1205")
--  elseif string.find(str,"袁天罡") then
--      result = CommandCenter:Execute("1206")
--  elseif string.find(str,"道士") then
--      result = CommandCenter:Execute("1207")
--  elseif string.find(str,"李世民") then
--      result = CommandCenter:Execute("1208")
--  elseif string.find(str,"信使") then
--      result = CommandCenter:Execute("1209")
--  elseif string.find(str,"孙悟空") then
--      result = CommandCenter:Execute("1210")
--  elseif string.find(str,"大大王") then
--      result = CommandCenter:Execute("1211")
--  end

--  return result
-- end
]]


return cmd