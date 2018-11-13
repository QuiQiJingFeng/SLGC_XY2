local File = class("File")
require "json"
function File:ctor()
    self.__data = {}
end

function File:pushValueFromKey(key,value)
    self.__data[key] = value
end

function File:saveToJson(path)
    local content = json.encode(self.__data)
    local file = io.open(path,"wb")
    file:write(content)
    file:close()
end

return File