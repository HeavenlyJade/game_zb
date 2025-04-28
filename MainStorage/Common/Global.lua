MS = {}

-- Common Services
MS.RunService = game:GetService("RunService")
MS.Players = game:GetService("Players")
MS.TweenService = game:GetService("TweenService")
MS.WorkSpace = game:GetService("WorkSpace")
MS.Environment = MS.WorkSpace.Environment
MS.MainStorage = game:GetService("MainStorage")
MS.ServerStorage = game:GetService("ServerStorage")
MS.ContextActionService = game:GetService("ContextActionService")
MS.UserInputService = game:GetService("UserInputService")
MS.WorldService = game:GetService("WorldService")
MS.DeveloperStoreService = game:GetService("DeveloperStoreService") -- 迷你币商品服务
MS.CoreUi = game:GetService("CoreUi") -- 游戏核心界面信息
MS.PhysXService = game:GetService("PhysXService")
MS.FriendInviteService = game:GetService("FriendInviteService") -- 好友拉新
MS.StarterGui = game:GetService("StarterGui")
MS.TeleportService = game:GetService("TeleportService") -- 传送服务
MS.AnalyticsService = game:GetService("AnalyticsService") -- 数据埋点服务
MS.UtilService = game:GetService("UtilService")
MS.MouseService = game:GetService("MouseService") -- 鼠标服务
MS.CloudServerConfigService = game:GetService("CloudServerConfigService")
MS.SceneMgr = game:GetService("SceneMgr") -- 副本服务
MS.CustomConfigService = game:GetService("CustomConfigService")

print("Service Ready")
-- Class
MS.Class = require(MS.MainStorage.Common.Utils.Class)
MS.Logging = require(MS.MainStorage.Common.Utils.Logging)

-- Common
MS.Const = require(MS.MainStorage.Common.Const)
MS.Bridge = require(MS.MainStorage.Common.Bridge)
MS.Protocol = require(MS.MainStorage.Common.Bridge.Protocol)
MS.Tween = require(MS.MainStorage.Common.Tween)
MS.EventObject = require(MS.MainStorage.Common.EventObject)
MS.DataConfig = require(MS.MainStorage.Common.DataConfig)
MS.Logging:Info("Common Ready")

-- Utils
MS.Utils = require(MS.MainStorage.Common.Utils)
MS.Math = require(MS.MainStorage.Common.Utils.Math)
MS.Config = require(MS.MainStorage.Common.Utils.Config)
MS.UidGenerator = require(MS.MainStorage.Common.Utils.UidGenerator)
MS.Timer = require(MS.MainStorage.Common.Utils.Timer)
MS.TargetUtils = require(MS.MainStorage.Common.Utils.TargetUtils)
MS.Logging:Info("Utils Ready")

-- Controller
MS.Controller = require(MS.MainStorage.Controller.Controller)
MS.PlayerController = require(MS.MainStorage.Controller.PlayerController)
MS.AIController = require(MS.MainStorage.Controller.AIController)

-- Actor
MS.ActorBase = require(MS.MainStorage.Actor.ActorBase)
MS.ActorComponent = require(MS.MainStorage.Actor.ActorComponent)
MS.ActorManager = require(MS.MainStorage.Actor.ActorManager)
MS.Logging:Info("Actor Ready")

-- Character
MS.CameraController = require(MS.MainStorage.Camera.CameraController)
MS.CameraRun = require(MS.MainStorage.Camera.CameraRun)
MS.WeaponPlant = require(MS.MainStorage.Character.WeaponPlant)

-- UI
MS.UIRoot = require(MS.MainStorage.UI.UIRoot)
MS.UIRootFunctionality = require(MS.MainStorage.UI.UIRootFunctionality)
MS.UIRootPrefab = MS.MainStorage.UI.UIRootPrefab
MS.UIRootPrefabFunctionality = MS.MainStorage.UI.UIRootPrefabFunctionality
MS.Logging:Info("UI Ready")

-- Player
MS.PlayerCharacter = require(MS.MainStorage.Player.PlayerCharacter)
MS.PlayerState = require(MS.MainStorage.Player.PlayerState)
MS.PlayerHUD = require(MS.MainStorage.Player.PlayerHUD)
MS.PlayerCardLoadout = require(MS.MainStorage.Player.PlayerCardLoadout)
MS.Logging:Info("Player Ready")

-- Sound
MS.SoundCue = require(MS.MainStorage.Sound.SoundCue)
MS.Logging:Info("Sound Ready")

-- Navigation
MS.NavigationSystem = require(MS.MainStorage.Navigation.NavigationSystem)
MS.NavigationMesh = require(MS.MainStorage.Navigation.NavigationMesh)
MS.Logging:Info("Navigation Ready")

--Subsystem
-- CardSystem
MS.WeaponPlantCard = require(MS.MainStorage.Subsystem.CardSystem.WeaponPlantCard)

-- Postprocessing
MS.PostProcessing = require(MS.MainStorage.PostProcessing.PostProcessing)

-- Test
MS.Test = MS.MainStorage.Test

-- Level
MS.Level = require(MS.MainStorage.Level:WaitForChild("Level"))
MS.LevelManager = require(MS.MainStorage.Level:WaitForChild("LevelManager"))

-- GameMode
MS.GameMode = require(MS.MainStorage.Level:WaitForChild("GameMode"))

--
-- ZombieMgr = require(MS.MainStorage:WaitForChild("ZombieMgr"))
local loadMainStorageNames = {
    "ObjectPool",
    "SceneManager",
    "WeatherManager",
    "NodeDataListenerManager",
    "LobbyScene",
    "EffectManager",
    "ZombieMgr",
    "ZManager",
    "SoundManager",
    "EffectNodePool",
    "TimerMgr",
    "SoundNodePool"
}
for i, v in ipairs(loadMainStorageNames) do
    _G[v] = require(MS.MainStorage:WaitForChild(v))
end
ZombieMgr.Init()
SoundManager.Init()
EffectNodePool:Init()
SoundNodePool:Init()
TimerMgr.Init()

if MS.RunService:IsServer() then
    MS.CloudManager = require(MS.ServerStorage.CloudManager)
    MS.ServerCardManager = require(MS.ServerStorage.ServerCardManager)
end

MS.Logging:Info("All Manager Ready")

return MS
