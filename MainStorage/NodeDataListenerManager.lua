local M = {}

M.listeners = setmetatable({}, {__mode = "k"})
M.listenerIdNodeMap = setmetatable({}, {__mode = "v"})
M.nodeListeners = {}
M.listenerIdCount = 0

function M.GenListenerId()
    M.listenerIdCount = M.listenerIdCount + 1
    return M.listenerIdCount
end

function M.AddNodeListener(node)
    if M.listeners[node] == nil then
        local newId = M.GenListenerId()
        local ins1 = node.NotifyAttributeChanged:Connect(function(key)
            M.OnNodeChange(newId, key)
        end)
        local ins2 = node.NotifyCustomAttrChanged:Connect(function(key)
            M.OnNodeChange(newId, key)
        end)
        M.listeners[node] = {ins1, ins2, newId}
        M.listenerIdNodeMap[newId] = node
    end
    return M.listeners[node][3]
end

function M.GetNodeListenerId(node)
    if M.listeners[node] ~= nil then
        return M.listeners[node][3]
    end
    return nil
end

function M.RemoveNodeListener(node)
    if M.listeners[node] ~= nil then
        M.listeners[node][1]:Disconnect()
        M.listeners[node][2]:Disconnect()
        M.listeners[node] = nil
    end
end

function M.AddNodeAttributeListener(node, key, func)
    local id = M.AddNodeListener(node)
    if M.nodeListeners[id] == nil then
        M.nodeListeners[id] = {}
    end
    M.nodeListeners[id][key] = {1, func}
end

function M.AddNodeKeyAttributeListener(node, key, fields, func)
    local id = M.AddNodeListener(node)
    if M.nodeListeners[id] == nil then
        M.nodeListeners[id] = {}
    end
    M.nodeListeners[id][key] = {2, fields, func}
    for _, fieldName in ipairs(fields) do
        local value = node:GetAttribute(fieldName)
        if value == nil then
            value = node[fieldName]
        end
        func(fieldName, value)
    end
end

function M.RemoveNodeAttributeListener(node, key)
    local id = M.GetNodeListenerId(node)
    if M.nodeListeners[id] ~= nil then
        M.nodeListeners[id][key] = nil
    end
end

function M.CallNodeFuncAndValue(func, node, key)
    local value = node:GetAttribute(key)
    if value == nil then
        value = node[key]
    end
    if value ~= nil then
        func(key, value)
    end
end

function M.OnNodeChange(nodeId, key)
    local node = M.listenerIdNodeMap[nodeId]
    if node == nil then
        return
    end
    local listener = M.nodeListeners[nodeId]
    if listener == nil then
        return
    end
    for _, listenerItem in pairs(listener) do
        local listenerType = listenerItem[1]
        if listenerType == 1 then
            M.CallNodeFuncAndValue(listenerItem[2], node, key)
        elseif listenerType == 2 then
            local fields = listenerItem[2]
            local func = listenerItem[3]
            for _, fieldName in ipairs(fields) do
                if fieldName == key then
                    M.CallNodeFuncAndValue(func, node, key)
                    break
                end
            end
        end
    end
end

function M.test()
    local ws = game:GetService("Workspace")
    local Zombie = ws.Zombie
    local Target = ws.Target
    M.AddNodeKeyAttributeListener(Zombie, "test_key_1111__", function(key)
        print("Zombie key changed: ", key)
    end)
    M.AddNodeKeyAttributeListener(Target, "test_key_1111__", function(key)
        print("target key changed: ", key)
    end)
    print("111111")
    Zombie.LocalPosition = Vector3.new(1, 2, 3)
    Target.LocalPosition = Vector3.new(1, 2, 3)
    Zombie:AddAttribute("zombie_value", Enum.AttributeType.Number)
    Zombie:SetAttribute("zombie_value", 100)
    Target:AddAttribute("Target_value", Enum.AttributeType.Number)
    Target:SetAttribute("Target_value", 200)
    print("222222")
    Zombie.LocalPosition = Vector3.new(1, 2, 3)
    Target.LocalPosition = Vector3.new(1, 2, 3)
    Zombie:SetAttribute("zombie_value", 100)
    Target:SetAttribute("Target_value", 200)
    print("333333")
    M.RemoveNodeAttributeListener(Zombie, "test_key_1111__")
    M.RemoveNodeAttributeListener(Target, "test_key_1111__")
    print("444444")
    Zombie.LocalPosition = Vector3.new(10, 2, 3)
    Target.LocalPosition = Vector3.new(10, 2, 3)
    Zombie:SetAttribute("zombie_value", 110)
    Target:SetAttribute("Target_value", 220)
    print("555555")
end

return M