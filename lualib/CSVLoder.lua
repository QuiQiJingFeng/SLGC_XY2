local v = {}

v.__cache = {}
--加载CSV
function v:LoadCSV(path)
    local data = self.__cache[path]
    if data then
        return data
    end
    local file = io.open(path,"rb")
    local content = file:read("*a")
    file:close()
    content = string.gsub(content, "\r","")
    local list = string.split(content,"\n")
    local typedata = {}
    local keys = string.split(list[1],",")
    local types = string.split(list[2],",")
    for idx,key in ipairs(keys) do
        typedata[key] = types[idx];
    end

    local data = {}
    for i = 3, #list do
        local line = list[i]
        local values = string.split(line,",")
 
        local cell = {}
        for idx,value in ipairs(values) do
            local key = keys[idx]
            local type = types[idx]
            local var = nil
            if type == "number" then
                var = tonumber(value) or 0
                if not var then
                    print("FYD--->>>var = ")
                end
                
            elseif type == "string" then
                var = tostring(value) or ""
            end
            if key then
                cell[key] = var
            end
        end
        if cell.name then
            --必须有ID 才会存入到数组中,这样可以在不指定ID的情况下写注释
            data[cell.name] = cell            
        end
    end
    self.__cache[path] = data
    return data
end

return v