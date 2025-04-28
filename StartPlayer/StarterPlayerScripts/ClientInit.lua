local MainStorage = game:GetService("MainStorage")
local MS = require(MainStorage.Common:WaitForChild("Global"))
_G.MS = MS

local function Init()
    _G.GameMode = MS.GameMode.new()
    _G.GameMode:Init()
    _G.GameMode.levelManager:SwitchLevel("Level1")

	ZManager:Init()

    _G.PlayerController = MS.PlayerController.new()
    _G.PlayerController:Init()
    _G.PlayerController.eventObject:FireEvent("OnEnterLobby")
end

-- PlayerAdded事件是在Init之后才发出
Init()
