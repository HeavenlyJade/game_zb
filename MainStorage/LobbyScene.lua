local MainStorage = game:GetService("MainStorage")
local SceneManager = require(MainStorage.SceneManager)
local M = {}

M.id = SceneManager.LobbySceneId
SceneManager.RegisterScene(M)

function M.OnEnter()
    -- init ui
    M.InitUI()
    M.InitPlayerData()
end

function M.OnExit()
    -- clear ui
end

function M.OnUpdate(dt)
end

function M.InitUI()
end

function M.InitPlayerData()
    M.selfPlayer = {}
    
end



return M