local Serialization = {}

-- table序列化成string
Serialization.tab2str = function(obj)
    local str = ""
    local t = type(obj)
    if t == "number" then
        str = str .. obj
    elseif t == "boolean" then
        str = str .. tostring(obj)
    elseif t == "string" then
        str = str .. string.format("%q", obj)
    elseif t == "table" then
        local bFix = false
        str = str .. "{"
        for k, v in pairs(obj) do
            str = str .. "[" .. Utils.tab2str(k) .. "]=" .. Utils.tab2str(v) .. ", "
            bFix = true
        end
        if bFix then
            str = string.sub(str, 1, #str - 2)
        end
        local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
            bFix = false
            for k, v in pairs(metatable.__index) do
                str = str .. "[" .. Utils.tab2str(k) .. "]=" .. Utils.tab2str(v) .. ", "
                bFix = true
            end
            if bFix then
                str = string.sub(str, 1, #str - 2)
            end
        end
        str = str .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not serialize a " .. t .. " type.")
    end
    return str
end

-- string反序列化table
Serialization.str2tab = function(str)
    local t = type(str)
    if t == "nil" or str == "" then
        return nil
    elseif t == "number" or t == "string" or t == "boolean" then
        str = tostring(str)
    else
        error("can not unserialize a " .. t .. " type.")
    end
    str = "return " .. str
    local func = load(str)
    if func == nil then
        return nil
    end
    return func()
end

return Serialization