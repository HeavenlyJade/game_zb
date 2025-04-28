local M = {}
M.nodeIdCount = 0
M.nodeTypeIdCount = 0
M.typeCloneTemplates = {}
M.typePools = {}
M.typeEmptyLists = {}
M.idNodeMap = setmetatable({}, {__mode = "v"})
M.typeNodeMap = setmetatable({}, {__mode = "k"})

function M.RegisterType(newType, cloneTemplate)
    M.typeCloneTemplates[newType] = cloneTemplate
end

function M.SpawnObject(newType)
    local template = M.typeCloneTemplates[newType]
    if template == nil then
        return nil
    end
    local typePool = M.typePools[newType]
    if typePool == nil then
        M.typePools[newType] = {}
        typePool = M.typePools[newType]
    end
    local ret = template:Clone()
    local id = M.AddNode(ret)
    M.AddTypeAndStatus(ret, newType, 1)
    typePool[id] = ret
    return ret
end

function M.RecycleObject(object)
    local status = M.GetStatusOrNil(object)
    if status == nil then
        return
    end
    if status ~= 1 then
        return
    end
    local objType = M.GetTypeOrNil(object)
    if objType == nil then
        return
    end
    local typeEmptyList = M.typeEmptyLists[objType]
    if typeEmptyList == nil then
        M.typeEmptyLists[objType] = {}
        typeEmptyList = M.typeEmptyLists[objType]
    end
    typeEmptyList[#typeEmptyList + 1] = object
    M.SetStatus(object, 2)
end

function M.GetObject(newType)
    local typeEmptyList = M.typeEmptyLists[newType]
    if typeEmptyList ~= nil and #typeEmptyList > 0 then
        local obj = typeEmptyList[#typeEmptyList]
        typeEmptyList[#typeEmptyList] = nil
        M.SetStatus(obj, 1)
        return obj
    end
    local obj = M.SpawnObject(newType)
    return obj
end

function M.GenNodeTypeId()
    M.nodeTypeIdCount = M.nodeTypeIdCount + 1
    return M.nodeTypeIdCount
end

function M.GenNodeId()
    M.nodeIdCount = M.nodeIdCount + 1
    return M.nodeIdCount
end

function M.AddNode(node)
    local id = M.GenNodeId()
    M.idNodeMap[id] = node
    return id
end

function M.GetNodeOrNil(id)
    return M.idNodeMap[id]
end

function M.AddTypeAndStatus(node, type, status)
    M.typeNodeMap[node] = {type, status}
end

function M.GetTypeOrNil(node)
    if M.typeNodeMap[node] == nil then
        return nil
    end
    return M.typeNodeMap[node][1]
end

function M.GetStatusOrNil(node)
    if M.typeNodeMap[node] == nil then
        return nil
    end
    return M.typeNodeMap[node][2]
end

function M.SetStatus(node, status)
    if M.typeNodeMap[node] == nil then
        return
    end
    M.typeNodeMap[node][2] = status
end

function M.test()
    local ws = game:GetService("Workspace")
    local zombieType1 = 1
    local zombieType2 = 2
    M.RegisterType(zombieType1, ws.Zombie)
    M.RegisterType(zombieType2, ws.Target)

    -- 创建1000个僵尸1和1000个僵尸2
    local ids = {}
    local ids2 = {}
    for i = 1, 5 do
        local zombie1 = M.GetObject(zombieType1)
        local zombie2 = M.GetObject(zombieType2)
        -- print(zombie1, zombie2, zombie1.Name, zombie2.Name)
        zombie1.Name = tostring(i + 10000)
        zombie2.Name = tostring(i + 30000)
        -- print(zombie1, zombie2, zombie1.Name, zombie2.Name)

        zombie1.Parent = ws
        zombie2.Parent = ws
        ids[#ids + 1] = M.GetNodeOrNil(zombie1)
        ids2[#ids2 + 1] = M.GetNodeOrNil(zombie2)
        M.RecycleObject(zombie1)
        M.RecycleObject(zombie2)
        M.RecycleObject(zombie1)
        M.RecycleObject(zombie2)
        zombie1 = M.GetObject(zombieType1)
        zombie2 = M.GetObject(zombieType2)
        -- print(zombie1, zombie2, zombie1.Name, zombie2.Name)
        -- M.RecycleObject(zombie1)
        -- M.RecycleObject(zombie2)
    end
end


return M