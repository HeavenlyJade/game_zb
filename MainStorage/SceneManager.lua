-- 负责管理各个GameScene/LobbyScene/ResultScene等各种Scene
local rs = game:GetService("RunService")

local M = {}
M.sceneIdMap = {}
M.activeScene = {}
M.isLockActiveScene = false
M.lockActiveActions = {}
M.renderSteppedIns = nil
M.sceneIdCount = 0

M.LobbySceneId      = 0x100
M.SimpleZombieScene = 0x200

function M.Init()
    if M.renderSteppedIns ~= nil then
        return
    end
    M.renderSteppedIns = rs.RenderStepped:Connect(M.UpdateScene)
end

function M.GenScneId()
    M.sceneIdCount = M.sceneIdCount + 1
    return M.sceneIdCount
end

function M.RegisterScene(scene)
    local id = scene.id
    M.sceneIdMap[id] = scene
end

function M.GetScene(id)
    return M.sceneIdMap[id]
end

function M.IsSceneActive(id)
    for i,v in ipairs(M.activeScene) do
        if v.id == id then
            return true
        end
    end
    return false
end

function M.OpenScene(id)
    if M.isLockActiveScene then
        M.lockActiveActions[#M.lockActiveActions+1] = {id, 1}
        return
    end
    local scene = M.GetScene(id)
    if scene == nil then
        return
    end
    for i,v in ipairs(M.activeScene) do
        if v.id == scene.id then
            return
        end
    end
    M.activeScene[#M.activeScene+1] = scene
    scene.OnEnter()
end

function M.CloseScene(id)
    if M.isLockActiveScene then
        M.lockActiveActions[#M.lockActiveActions+1] = {id, 2}
        return
    end
    local scene = M.GetScene(id)
    if scene == nil then
        return
    end
    for i,v in ipairs(M.activeScene) do
        if v.id == scene.id then
            scene.OnExit()
            table.remove(M.activeScene, i)
            return
        end
    end
end

function M.UpdateScene(dt)
    M.isLockActiveScene = true
    for i,v in ipairs(M.activeScene) do
        v.OnUpdate(dt)
    end
    M.isLockActiveScene = false
    if #M.lockActiveActions > 0 then
        for i,v in ipairs(M.lockActiveActions) do
            if v[2] == 1 then
                M.OpenScene(v[1])
            elseif v[2] == 2 then
                M.CloseScene(v[1])
            end
        end
        M.lockActiveActions = {}
    end
end

function M.test()
    M.Init()
    local newScene = {}
    newScene.id = M.GenScneId()
    M.RegisterScene(newScene)
    newScene.OnEnter = function()
        print("OnEnter")
    end
    newScene.OnExit = function()
        print("OnExit")
    end
    newScene.OnUpdate = function(dt)
        print("OnUpdate")
    end
    M.OpenScene(newScene.id)
    Wait(2)
    M.CloseScene(newScene.id)
end


return M