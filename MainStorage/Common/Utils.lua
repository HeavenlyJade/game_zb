local Utils = {}

_G.PCall = function(func, actor)
    func()
end

-- Add a custom func to stringlib
local string = _G.string
string.split = function(str, mark, magic, plain)
    local t = {}
    local i = 0
    local j = 1
    local max = string.len(str)
    local z = string.len(mark)
    if magic then
        z = z - 1
    end
    while true do
        i = string.find(str, mark, i + 1, plain) -- 查找下一行
        if i == nil then
            if j <= max then
                table.insert(t, string.sub(str, j, -1))
            end
            break
        end
        table.insert(t, string.sub(str, j, i - 1))
        j = i + z
    end
    return t
end

function PCALL(func)
    local status, err
    if debug then
        status, err = xpcall(func, debug.traceback)
    else
        status, err = pcall(func)
    end
    if false == status then
        ERR("error : " .. (err or 0))
    end
end

-- 删除表中得元素
function Utils.RemoveTabEle(tab, ele)
    for k, v in pairs(tab) do
        if (v == ele) then
            table.remove(tab, k)
        end
    end
end

function Utils.Split(str, delimiter)
    local dLen = string.len(delimiter)
    local newDeli = ""
    for i = 1, dLen, 1 do
        newDeli = newDeli .. "[" .. string.sub(delimiter, i, i) .. "]"
    end

    local locaStart, locaEnd = string.find(str, newDeli)
    local arr = {}
    local n = 1
    while locaStart ~= nil do
        if locaStart > 0 then
            arr[n] = string.sub(str, 1, locaStart - 1)
            n = n + 1
        end

        str = string.sub(str, locaEnd + 1, string.len(str))
        locaStart, locaEnd = string.find(str, newDeli)
    end
    if str ~= nil then
        arr[n] = str
    end
    return arr
end

-- 获取当前时间戳，精确到秒
function Utils.GetCurrentSecond()
    return math.floor(MS.RunService:CurrentMilliSecondTimeStamp() / 1000)
end

-- 获取当前时间戳，精确到毫秒
function Utils.GetCurrentMilliSecond()
    return MS.RunService:CurrentMilliSecondTimeStamp()
end

-- -- 通过路径加载节点
-- function Utils.LoadDescendantByPath(node, path)
--     local rets = string.split(path, "/")
--     local descendant = node
--     for i = 1, #rets do
--         descendant = descendant:WaitForChild(rets[i])
--     end
--     return descendant
-- end

-- 秒数 格式化输出为 xD xx:xx:xx
function Utils.Time2string(time)
    if time < 0 then
        return "00:00:00"
    end
    local hour = math.floor((time / 3600) % 24)
    local minute = math.fmod(math.floor(time / 60), 60)
    local second = math.fmod(time, 60)

    local str = "" -- string.format("%02d:%02d:%02d",hour,minute,second)

    if time >= 3600 * 24 then
        local day = math.floor(time / (3600 * 24))
        local hour = math.floor((time / 3600) % 24)
        local minute = math.fmod(math.floor(time / 60), 60)
        local second = math.fmod(time, 60)
        if hour == 0 and minute == 0 and second == 0 then
            str = day .. "D "
        else
            str = day .. "D " .. str
        end
    elseif time > 3600 then
        str = string.format("%02d:%02d:%02d", hour, minute, second)
    else
        str = string.format("%02d:%02d", minute, second)
    end

    return str
end

-- 获取table长度
function Utils.GetTableLength(tbl)
    if type(tbl) ~= "table" then
        return 0
    end

    local cnt = 0
    for k, v in pairs(tbl) do
        cnt = cnt + 1
    end
    return cnt
end

Utils.table2str = function(tbl)
    local tab = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            tab[#tab + 1] = tostring(k) .. "={" .. Utils.table2str(v) .. "}"
        else
            tab[#tab + 1] = tostring(k) .. "=" .. tostring(v)
        end
    end
    return table.concat(tab, " ")
end

Utils.Array2Vec3 = function(arr)
    return Vector3.new(arr[1], arr[2], arr[3])
end

-- 根据路径获取WorkSpace下的节点
function Utils.GetWorkSpaceNode(path)
    -- 通过.号分割path
    local function split(str, sep)
        local result = {}
        local regex = ("([^%s]+)"):format(sep)
        for each in str:gmatch(regex) do
            table.insert(result, each)
        end
        return result
    end
    local nodeNameList = split(path, ".")
    local node = MS.WorkSpace
    if node then
        for _, name in ipairs(nodeNameList) do
            node = node[name]
            if node == nil then
                print("Can not find node : " .. name)
                break
            end
        end
    end
    return node
end

function Utils:ShallowCopy(orig, customCopy)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = Utils:ShallowCopy(orig_value, customCopy)
        end
    else -- number, string, boolean, etc
        if customCopy then
            copy = customCopy(orig)
        else
            copy = orig
        end
    end
    return copy
end

function Utils.DeepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function Utils.Tick()
    return MS.RunService:CurrentMilliSecondTimeStamp()
end

-- LineTrace function
-- 尝试得到鼠标点击的位置的地面位置
function Utils.TryGetRaycastUnderCursor(mouseInputObject, depth, ignoreTrigger, filterGroup)
    local mousePositionX = mouseInputObject.Position.x
    local mousePositionY = mouseInputObject.Position.y
    local viewportSize = MS.WorkSpace.CurrentCamera.ViewportSize
    local ray = MS.WorkSpace.CurrentCamera:ViewportPointToRay(mousePositionX, viewportSize.y - mousePositionY, depth)
    local ret_table = MS.WorldService:RaycastClosest(ray.Origin, ray.Direction, depth, ignoreTrigger, filterGroup)
    if ret_table.isHit == false then
        depth = 1500
        ret_table.position = ray.Origin + ray.Direction * depth
    end

    if ret_table.isHit == true and ret_table.distance < 500 then
        depth = 500
        ret_table.position = ray.Origin + ray.Direction * depth
    end

    return ret_table
end

return Utils
