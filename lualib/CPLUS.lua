local CPLUS = {}
local meta = {}
local dmproject = require("dmproject")
setmetatable(CPLUS,meta)

meta.__index = function(tb,className)

	local internal = {}
	local internal_meta = {}
	setmetatable(internal,internal_meta)
	internal_meta.__index = function(tb,funcName)
		return function(...)
			return dmproject.excute(className,funcName,...)
		end
	end

	return internal
end

return CPLUS