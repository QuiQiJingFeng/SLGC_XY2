local skynet = require "skynet"
local HardWareUtil = {}
local meta = {}
setmetatable(HardWareUtil, meta)

meta.__index = function(tb,key)
    return function(self,...)
        local dm = DMCenter:GetDm() or ""
        local hwnd = DMCenter:GetHwnd() or ""
        --MARK if ... then paramaters must be none nil else not array
        local ret = skynet.call(".hardware", "lua", key, dm, hwnd, ...)
        --FYD MARK 如果放到键鼠服务中的话,会使所有的客户端进入等待时间,
        --而放到这里,可以仅仅让这个客户端进行等待
        return ret
    end
end

return HardWareUtil