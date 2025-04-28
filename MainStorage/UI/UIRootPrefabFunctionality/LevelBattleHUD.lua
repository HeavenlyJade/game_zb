local LevelBattleHUDFunctionality = MS.Class.new("LevelBattleHUDFunctionality", MS.UIRootPrefabFunctionality)

function LevelBattleHUDFunctionality:InitFireButton()
    -- Fire Button
    --self.fireIcon_Left = self.owner.bindingUI.MainPanel.FireButton_Left.Background.FireIcon
    self.fireIcon_Right = self.owner.bindingUI.MainPanel.FireButton_Right

    -- self.fireIcon_Left.TouchBegin:Connect(
    --     function(node, isTouchMove, vector2, int)
    --         _G.PlayerController:OnFireInputBegin(vector2)
    --     end
    -- )

    -- self.fireIcon_Left.TouchEnd:Connect(
    --     function(node, isTouchMove, vector2, int)
    --         _G.PlayerController:OnFireInputEnd()
    --     end
    -- )
    -- self.fireIcon_Left.TouchMove:Connect(
    --     function(node, isTouchMove, vector2, int)
    --         _G.PlayerController:OnFireInputMove(vector2)
    --     end
    -- )
    self.fireIcon_Right.TouchBegin:Connect(
        function(node, isTouchMove, vector2, int)
            _G.PlayerController:OnFireInputBegin(vector2)
        end
    )

    self.fireIcon_Right.TouchEnd:Connect(
        function(node, isTouchMove, vector2, int)
            _G.PlayerController:OnFireInputEnd()
        end
    )
    self.fireIcon_Right.TouchMove:Connect(
        function(node, isTouchMove, vector2, int)
            _G.PlayerController:OnFireInputMove(vector2)
        end
    )
end

function LevelBattleHUDFunctionality:InitCrossHair()
    self.crossHairIcon = self.owner.bindingUI.MainPanel.CrossHair

    self.crossHairTimer =
        MS.Timer.CreateTimer(
        0.2,
        0.2,
        false,
        function()
            self.crossHairIcon.HitBG.Visible = false
        end
    )
end

function LevelBattleHUDFunctionality:Init()
    self:InitFireButton()
    self:InitCrossHair()

    local exitButton = self.owner.bindingUI.MainPanel.ExitButton
    exitButton.Click:Connect(
        function()
            print("send Tp Request")
            local playerId = MS.Players.LocalPlayer.UserId
            MS.Bridge.SendMessageToServer(
                MS.Protocol.ClientMsgID.TELEPORT_REQUEST,
                {playerId = playerId, mapId = 12839541415348}
            )
        end
    )

    -- Switch Weapon Plant Button
    self.selectedWeaponPlantIndex = 1
    local weaponPlantCards = _G.PlayerController.pawn.playerState.weaponPlantCards
    local plantsBar = self.owner.bindingUI.MainPanel.PlantsBar
    for k, _ in pairs(weaponPlantCards) do
        local weaponPlantConfig = MS.DataConfig.Config_WeaponPlant[weaponPlantCards[k].weaponPlantPrefab]
        local ammo = weaponPlantConfig.magazine
        local ammoCarry = weaponPlantConfig.magazine_carry

        local weaponPlantSlot =
            _G.PlayerController.playerHUD:CreateUIRoot("WeaponPlantSlot", "WeaponPlantSlot_" .. k, plantsBar)
        weaponPlantSlot.bindingFunctionality.slotIndex = k
        _G.PlayerController.eventObject:FireEvent("OnInitWeaponPlant", k)
        _G.PlayerController.playerHUD.eventObject:FireEvent("OnAttributeUpdate", k, "Health", 100, 100)
        _G.PlayerController.playerHUD.eventObject:FireEvent("OnAttributeUpdate", k, "Ammo", ammo, ammoCarry)
        _G.PlayerController.playerHUD.eventObject:FireEvent("OnAttributeUpdate", k, "Level", 1)
    end
end

function LevelBattleHUDFunctionality:Update(eventName, ...)
    if eventName == "OnFireInputBegin" then
        --self.fireIcon_Left.Icon = "SandboxId://PVZ_Icon/PlayerHUD/UI_HUD_BtnAttackEM.png"
        --self.fireIcon_Right.Icon = "SandboxId://PVZ_Icon/PlayerHUD/UI_HUD_BtnAttackEM.png"
    elseif eventName == "OnFireInputEnd" then
        --self.fireIcon_Left.Icon = "SandboxId://PVZ_Icon/PlayerHUD/UI_HUD_BtnAttackN.png"
        --self.fireIcon_Right.Icon = "SandboxId://PVZ_Icon/PlayerHUD/UI_HUD_BtnAttackN.png"
    elseif eventName == "OnFire" then
        local recoil = select(1, ...)
        -- 跟累计后座力挂钩
        self.crossHairIcon.Scale = Vector2.new(1 + recoil / 24, 1 + recoil / 24)
        if self.crossHairTween ~= nil then
            self.crossHairTween:Destroy()
        end
        local goal = {
            Scale = Vector2.new(0.67, 0.67)
        }
        self.crossHairTween = MS.Tween.CreateTween(self.crossHairIcon, goal, 0.5)
        self.crossHairTween:Play()
    elseif eventName == "OnFireHit" then
        self.crossHairIcon.HitBG.Visible = true
        if self.crossHairTimer:GetRunState() == Enum.TimerRunState.RUNNING then
            self.crossHairTimer:Stop()
        end
        self.crossHairTimer:Start()
    elseif eventName == "OnWaveStart" then
        local wave = select(1, ...)
        self.owner.bindingUI.MainPanel.LevelBar.WaveNum.Title =
            "剩余波次 " .. wave .. "/" .. _G.GameMode.levelManager.currentLevel.levelState.totalWaveCount
        self.owner.bindingUI.MainPanel.LevelBar.Background.FillAmount =
            (wave - 1) / _G.GameMode.levelManager.currentLevel.levelState.totalWaveCount
    elseif eventName == "OnZombieDead" then
        local deadZombieCount = select(1, ...)
        self.owner.bindingUI.MainPanel.KillZombieBar.KillNum.Title = "击杀数 " .. deadZombieCount
    elseif eventName == "OnSunflowerHit" then
        local health = select(1, ...)
        self.owner.bindingUI.MainPanel.Sunflower.HealthPercent.Title = "血量：" .. health
        self.owner.bindingUI.MainPanel.Sunflower.HeartBG.Heart.FillAmount = health / 100
    end
end

return LevelBattleHUDFunctionality
