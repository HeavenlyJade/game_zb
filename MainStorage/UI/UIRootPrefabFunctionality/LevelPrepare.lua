local LevelPrepareFunctionality = MS.Class.new("LevelPrepareFunctionality", MS.UIRootPrefabFunctionality)

function LevelPrepareFunctionality:ctor()
    self.selectedCardIcon = nil
    self.isInPlantingMode = false

    self.alternativeCards = {}
end

function LevelPrepareFunctionality:Init()
    local mainPanel = self.owner.bindingUI.MainPanel
    local playerCardLoadout = _G.PlayerController.playerCardLoadout

    self.alternativeCards = playerCardLoadout.playerCards

    self.alternativeCardsPanel = mainPanel.AlternativeCards
    self.confirmButton = mainPanel.ConfirmButton
    self.exitButton = mainPanel.ExitButton

    -- Init Alternative Cards
    _G.PlayerController.isPlantingMode = false
    local cardList = self.alternativeCardsPanel.CardListBG.CardList

    local weaponPlantGroup = _G.GameMode.levelManager.currentLevel.levelInstance:WaitForChild("WeaponPlantGroup")
    for _, child in pairs(weaponPlantGroup.Children) do
        child.EnablePhysics = true
        child.HaloEffect.Visible = true
        child.HaloEffect:Start()
    end

    for i = 1, #self.alternativeCards do
        local cardSlot = _G.PlayerController.playerHUD:CreateUIRoot("CardSlot", "CardSlot" .. i, cardList)
        cardSlot.bindingUI.BG.PlantIcon.Icon = self.alternativeCards[i].icon
        -- 创建TouchBegin事件
        cardSlot.bindingUI.Click:Connect(
            function()
                _G.PlayerController.isPlantingMode = true
                _G.PlayerController.selectedCard = self.alternativeCards[i]

                if self.selectedCardIcon ~= nil then
                    self.selectedCardIcon.Icon = "sandboxId://PVZ_UI/LevelPrepare/Bg_ChP_Plants_Off.png"
                end

                self.selectedCardIcon = cardSlot.bindingUI.BG
                cardSlot.bindingUI.BG.Icon = "sandboxId://PVZ_UI/LevelPrepare/Bg_ChP_Plants_On.png"
            end
        )
    end

    -- Init Confirm Button
    self.confirmButton.TouchBegin:Connect(
        function()
            local weaponPlantGroup = _G.GameMode.levelManager.currentLevel.levelInstance:WaitForChild("WeaponPlantGroup")
            local anyPlant = false
            for _, child in pairs(weaponPlantGroup.Children) do
                if child:GetAttribute("HasPlanted") then
                    anyPlant = true
                    break
                end
            end
            if not anyPlant then
                print("No plant!")
                return
            end
            for _, child in pairs(weaponPlantGroup.Children) do
                child.EnablePhysics = false
                child.HaloEffect.Visible = false
                child.HaloEffect:Pause()
            end
            self.selectedCardIcon.Icon = "sandboxId://PVZ_UI/LevelPrepare/Bg_ChP_Plants_Off.png"
            _G.PlayerController.isPlantingMode = false
            _G.PlayerController.selectedCard = nil
            _G.PlayerController.eventObject:FireEvent("OnLevelPrepareEnd")
            _G.GameMode.levelManager.eventObject:FireEvent("OnLevelStart")
        end
    )
    -- Init Exit Button
    self.exitButton.TouchBegin:Connect(
        function()
            print("send Tp Request")
            local playerId = MS.Players.LocalPlayer.UserId
            MS.Bridge.SendMessageToServer(
                MS.Protocol.ClientMsgID.TELEPORT_REQUEST,
                {playerId = playerId, mapId = 12839541415348}
            )
        end
    )
end

function LevelPrepareFunctionality:Update(eventName, ...)
end

return LevelPrepareFunctionality
