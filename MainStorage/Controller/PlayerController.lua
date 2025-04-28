local PlayerController = MS.Class.new("PlayerController", MS.Controller)
local localPlayer = game.Players.LocalPlayer

-- Need to unable all default Control first
function PlayerController:ctor()
    self.eventObject = MS.EventObject.new()
    self.eventNames = {
        "OnEnterLobby",
        "OnEnterCardLoadout",
        "OnExitCardLoadout",
        "OnEnterLevelMenu",
        "OnExitLevelMenu",
        "OnSelectLevel",
        "OnSelectLevelEnd",
        "OnLevelPrepareStart",
        "OnExitLevelPrepare",
        "OnLevelPrepareEnd",
        "OnPossessWeaponPlants",
        "OnInitWeaponPlant",
        "OnLevelStart",
        "OnWaveStart",
        "OnWaveEnd",
        "OnLevelEnd",
        "OnSwitchWeapon",
        "OnAttributeUpdate",
        "OnInstanceDie",
        "OnFireHit",
        "OnFire",
        "OnZombieDead",
        "OnCountDown",
        "OnSunflowerHit"
    }
    self.playerHUD = MS.PlayerHUD.new()
    self.playerCardLoadout = MS.PlayerCardLoadout.new()
end

function PlayerController:SetFov(fov)
    if self.cameraTween then
        self.cameraTween:Destroy()
    end
    self.cameraTween = MS.Tween.CreateTween(MS.WorkSpace.CurrentCamera, {FieldOfView = fov}, 0.2)
    self.cameraTween:Play()
end

-- Binding depending on the Device
function PlayerController:Init()
    self.playerHUD:Init()
    self:RegisterEvents()
    self:RegisterServerCallback()
    self:SetFov(50)
end

function PlayerController:PossessPawn(pawn)
    self.pawn = pawn
    self.pawn.controller = self
end

-- Input Event
function PlayerController:OnFireInputBegin(vector2)
    local postProcessing = MS.WorkSpace.Environment.PostProcessing
    postProcessing.ChromaticAberrationIntensity = 0.5
    postProcessing.ChromaticAberrationStartOffset = 0.9
    postProcessing.ChromaticAberrationIterationStep = 5
    postProcessing.ChromaticAberrationIterationSamples = 4

    self:SetFov(30)
    -- 给UI系统发送信息
    self.playerHUD.eventObject:FireEvent("OnFireInputBegin")
    -- 记录按下的位置
    self.fireInputBeginPos = vector2
    -- 这一句只能放在最下面，否则会堵塞后面的语句执行
    self.pawn.controlledWeaponPlantInstance:PullTrigger()
end

function PlayerController:OnFireInputEnd()
    local postProcessing = MS.WorkSpace.Environment.PostProcessing
    postProcessing.ChromaticAberrationIntensity = 1
    postProcessing.ChromaticAberrationStartOffset = 0.4
    postProcessing.ChromaticAberrationIterationStep = 0.01
    postProcessing.ChromaticAberrationIterationSamples = 1

    self:SetFov(50)
    -- 给UI系统发送信息
    self.playerHUD.eventObject:FireEvent("OnFireInputEnd")
    self.pawn.controlledWeaponPlantInstance:ReleaseTrigger()
end

function PlayerController:OnFireInputMove(vector2)
    -- 计算移动的距离
    local moveDistance = vector2 - self.fireInputBeginPos
    -- 更新按下的位置
    self.fireInputBeginPos = vector2
    self.pawn.controlledWeaponPlantInstance.actorComponents["CameraController"]:InputMove(
        moveDistance.x,
        moveDistance.y
    )
end

function PlayerController:OnSwitchWeapon(index)
    local weaponPlantInstances = _G.GameMode.levelManager.currentLevel.levelState.weaponPlantInstances
    for k, _ in pairs(weaponPlantInstances) do
        if k == index then
            self.pawn:SwitchWeaponPlant(k)
            self.playerHUD.eventObject:FireEvent("OnSwitchWeapon", k)
        end
    end
end

-- Input
-- For PC(Touch Device use UI Event)
function PlayerController:KeyMouseBinding()
    self:BindTPSContext()
end

function PlayerController:UnbindKeyMouseContext()
    self:UnbindTPSContext()
end

function PlayerController:BindTPSContext()
    -- TPS Context Map
    MS.ContextActionService:BindContext(
        "SwitchWeaponPlant",
        function(actionName, inputState, inputObj)
            if inputState == Enum.UserInputState.InputBegin.Value then
                -- 1 2 3 4 5
                local index = inputObj.KeyCode - 48
                self:OnSwitchWeapon(index)
            end
        end,
        false,
        Enum.UserInputType.Keyboard
    )
    -- Left Mouse Button for Shooting
    MS.ContextActionService:BindContext(
        "Fire",
        function(actionName, inputState, inputObj)
            if inputState == Enum.UserInputState.InputBegin.Value then
                self:OnFireInputBegin()
            elseif inputState == Enum.UserInputState.InputEnd.Value then
                self:OnFireInputEnd()
            end
        end,
        false,
        Enum.KeyCode.Space
    )
    -- Right Mouse Button for Aiming
    MS.ContextActionService:BindContext(
        "Aim",
        function(actionName, inputState, inputObj)
            if inputState == Enum.UserInputState.InputBegin.Value then
            end
            if inputState == Enum.UserInputState.InputEnd.Value then
            end
        end,
        false,
        Enum.UserInputType.MouseButton2
    )
    MS.ContextActionService:BindContext(
        "Reload",
        function(actionName, inputState, inputObj)
            if inputState == Enum.UserInputState.InputBegin.Value then
                self.pawn.controlledWeaponPlantInstance:TryReload()
            end
        end,
        false,
        Enum.KeyCode.R
    )
end

function PlayerController:BindPlantingModeContext()
    local function OnPlantingMode(actionName, inputState, inputObj)
        if _G.PlayerController.isPlantingMode == false then
            return
        end

        if inputState == Enum.UserInputState.InputBegin.Value then
            local raycastResult = MS.Utils.TryGetRaycastUnderCursor(inputObj, 3000, false, {1})
            print(raycastResult.isHit)

            local plantPos = raycastResult.obj
            if
                raycastResult.isHit and plantPos:GetAttribute("GameplayTag") == "WeaponPlantPosition" and
                    not plantPos:GetAttribute("HasPlanted")
             then
                print(plantPos.Name)
                print(type(plantPos:GetAttribute("HasPlanted")))
                print(plantPos:GetAttribute("HasPlanted"))

                _G.GameMode.levelManager.currentLevel:SpawnWeaponPlant(
                    plantPos:GetAttribute("PositionIndex"),
                    _G.PlayerController.selectedCard.weaponPlantPrefab
                )
                plantPos:SetAttribute("HasPlanted", true)
                _G.PlayerController.pawn.playerState:AddWeaponPlantCard(
                    _G.PlayerController.selectedCard,
                    plantPos:GetAttribute("PositionIndex")
                )
                plantPos.HaloEffect.Visible = false
                plantPos.HaloEffect:Pause()
            end
        end
    end

    MS.ContextActionService:BindContext(
        "PlantingMode1",
        function(actionName, inputState, inputObj)
            OnPlantingMode(actionName, inputState, inputObj)
        end,
        false,
        Enum.UserInputType.Touch
    )

    MS.ContextActionService:BindContext(
        "PlantingMode2",
        function(actionName, inputState, inputObj)
            OnPlantingMode(actionName, inputState, inputObj)
        end,
        false,
        Enum.UserInputType.MouseButton1
    )
end

function PlayerController:KeyMouseUnbinding()
    self:UnbindTPSContext()
end

function PlayerController:UnbindTPSContext()
    MS.ContextActionService:UnbindContext("SwitchWeaponPlant")
    MS.ContextActionService:UnbindContext("Fire")
    MS.ContextActionService:UnbindContext("Aim")
    MS.ContextActionService:UnbindContext("Reload")
end

function PlayerController:UnbindPlantingModeContext()
    MS.ContextActionService:UnbindContext("PlantingMode1")
    MS.ContextActionService:UnbindContext("PlantingMode2")
end

-- Event
function PlayerController:RegisterEvents()
    for _, eventName in pairs(self.eventNames) do
        self.eventObject:On(
            eventName,
            function(...)
                self:Update(eventName, ...)
            end
        )
    end
end

function PlayerController:RegisterServerCallback()
    MS.Bridge.RegisterServerMessageCallback(
        MS.Protocol.ServerMsgID.GETPLAYERCARDSCOMPLETE,
        function(messageId, messageBody)
            self.playerCardLoadout:Init(messageBody.playerCards)
        end
    )
end

function PlayerController:SendMessageToServer(msgid, body)
    MS.Bridge.SendMessageToServer(msgid, body)
end

function PlayerController:Update(eventName, ...)
    if eventName == "OnEnterLobby" then
        SoundManager.ReplaceBackground(SoundManager.SoundId_HallBackground)
        self.playerHUD:CreateUIRoot("Lobby", "Lobby", localPlayer.PlayerGui)
        wait(0.2)
        MS.CameraRun:Start("RouteLobby", true)
    elseif eventName == "OnEnterCardLoadout" then
        self.playerHUD:CreateUIRoot("PlayerCardLoadout", "PlayerCardLoadout", localPlayer.PlayerGui)
    elseif eventName == "OnExitCardLoadout" then
        self.playerHUD:DestroyUIRoot("PlayerCardLoadout")
    elseif eventName == "OnEnterLevelMenu" then
        self.playerHUD:DestroyUIRoot("Lobby")
        self.playerHUD:CreateUIRoot("LevelMenu", "LevelMenu", localPlayer.PlayerGui)
    elseif eventName == "OnExitLevelMenu" then
        self.playerHUD:DestroyUIRoot("LevelMenu")
        self.playerHUD:CreateUIRoot("Lobby", "Lobby", localPlayer.PlayerGui)
    elseif eventName == "OnSelectLevelEnd" then
        self.playerHUD:SetUIRootVisibility("LevelMenu", false)
    elseif eventName == "OnExitLevelPrepare" then
        self.playerHUD:DestroyUIRoot("LevelPrepare")
        self.playerHUD:CreateUIRoot("LevelMenu", "LevelMenu", localPlayer.PlayerGui)
    elseif eventName == "OnLevelPrepareStart" then
        --camera
        MS.CameraRun:Stop()
        local point = MS.CameraRun:GetPoint("RouteEnter", "Point001")
        local Camera = MS.WorkSpace.CurrentCamera
        Camera.CameraType = Enum.CameraType.Scriptable
        if point then
            Camera.Position = point.Position
            Camera.Euler = point.Euler
        else
            Camera.Position = Vector3.new(-207.485, 969.457, 173.123)
            Camera.Euler = Vector3.new(35.756, 0.105722, 0)
        end
        -- Init PlayerCharacter
        self.pawn = MS.PlayerCharacter.new()

        self:BindPlantingModeContext()
        self.playerHUD:CreateUIRoot("LevelPrepare", "LevelPrepare", localPlayer.PlayerGui)
    elseif eventName == "OnLevelPrepareEnd" then
        self:UnbindPlantingModeContext()

        self.playerHUD:CreateUIRoot("LevelStart", "LevelStart", localPlayer.PlayerGui)
        self.playerHUD:DestroyUIRoot("LevelPrepare")
        self.pawn:Init()
        self:PossessPawn(self.pawn)

        MS.CameraRun:Start("RouteEnter", false)
        self.playerHUD:CreateUIRoot("LevelBattleHUD", "LevelBattleHUD", localPlayer.PlayerGui)
    elseif eventName == "OnPossessWeaponPlants" then
        local weaponPlantInstances = select(1, ...)
        self.pawn:PossessWeaponPlant(weaponPlantInstances)
        for _, weaponPlantInstance in pairs(weaponPlantInstances) do
            if weaponPlantInstance then
                local slotIndex = weaponPlantInstance.bindActor.Parent:GetAttribute("PositionIndex")
                self.pawn.controlledWeaponPlantInstance = weaponPlantInstance
                self:OnSwitchWeapon(slotIndex)
                break
            end
        end
        self.pawn.controlledWeaponPlantInstance:AttachCameraComponent(self.pawn.cameraController)
        self.pawn.controlledWeaponPlantInstance.actorComponents["CameraController"]:StartClient()
    elseif eventName == "OnLevelStart" then
        SoundManager.ReplaceBackground(SoundManager.SoundId_BattleBackground)
        SoundManager.Play(SoundManager.SoundId_BattleBegin, false)
        EffectManager.AddRain()

        self:KeyMouseBinding()
    elseif eventName == "OnWaveStart" then
        SoundManager.Play(SoundManager.SoundId_ZombieComing, false, 5000)
    elseif eventName == "OnLevelEnd" then
        -- end battle
        EffectManager.RemoveRain()
        local win = ...
        local soundId = SoundManager.SoundId_ResultDefeat
        if win then
            soundId = SoundManager.SoundId_ResultWin
        end
        SoundManager.Play(soundId, false, 5000)
        self:KeyMouseUnbinding()
        self.playerHUD:DestroyUIRoot("LevelBattleHUD")
        self.playerHUD:CreateUIRoot("LevelEnd", "LevelEnd", localPlayer.PlayerGui)
    elseif eventName == "OnInstanceDie" then
    elseif eventName == "OnGetNewCard" then
        local card = select(1, ...)
        self.playerCardLoadout:AddCard(card)
    elseif eventName == "OnZombieDead" then
        local deadZombieCount = select(1, ...)
        self.playerHUD.eventObject:FireEvent("OnZombieDead", deadZombieCount)
    end

    self.playerHUD.eventObject:FireEvent(eventName, ...)
end

return PlayerController
