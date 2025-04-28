local MainStorage = game:GetService("MainStorage")
local MS = require(MainStorage.Common:WaitForChild("Global"))
_G.MS = MS

local function Init()
    _G.CloudManager = MS.CloudManager.new()
    _G.CloudManager:Init()

    _G.ServerCardManager = MS.ServerCardManager.new()
    _G.ServerCardManager:Init()
end

Init()

local CloudService = game:GetService("CloudService")
local Players = game:GetService("Players")
local GameSetting = game:GetService("GameSetting")
local ServerScriptService = game:GetService("ServerScriptService")

local CommonNode = MainStorage:WaitForChild("Common")
local BridgeNode = CommonNode:WaitForChild("Bridge")
local ProtocolNode = BridgeNode:WaitForChild("Protocol")
local TpServiceNode = ServerScriptService:WaitForChild("TPService")

_G.Bridge = require(BridgeNode)
_G.Protocol = require(ProtocolNode)
_G.TpService = require(TpServiceNode)

TpService.StartService()
