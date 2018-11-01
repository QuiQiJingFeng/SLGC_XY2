local skynet = require "skynet"

local format = function(...)
    local success, str = pcall(string.format, ...)
    if success then
        return str
    else
        return table.concat({...}, ", ")
    end
end

local log = {}

local function _log(level, msg)
    skynet.error(format("[%s][%s][%s]%s", level, SERVICE_NAME,tostring(skynet.self()), msg))
end

function log.debug(msg)
    _log("DEBUG", msg)
end
function log.info(msg)
    _log("INFO", msg)
end
function log.warning(msg)
    _log("WARNING", msg)
end
function log.error(msg)
    _log("ERROR", msg .. debug.traceback("", 2))
    skynet.exit()
end

function log.debugf(...)
    log.debug(format(...))
end
function log.infof(...)
    log.info(format(...))
end
function log.warningf(...)
    log.warning(format(...))
end
function log.errorf(...)
    log.error(format(...))
    skynet.exit()
end

return log