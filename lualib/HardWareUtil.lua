local skynet = require "skynet"
local HardWareUtil = {}
local meta = {}
setmetatable(HardWareUtil, meta)

meta.__index = function(tb,key)
    return function(self,...)
        local dm = game.dmcenter:GetDm() or ""
        local hwnd = game.dmcenter:GetHwnd() or ""
        -- if string.find(key,"Click") then
        --     game.log.debug(debug.traceback())
        -- end
        return skynet.call(".hardware", "lua", key, dm, hwnd, ...)
    end
end

return HardWareUtil