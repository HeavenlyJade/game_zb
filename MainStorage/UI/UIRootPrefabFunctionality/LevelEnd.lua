local LevelEndFunctionality = MS.Class.new("LevelEndFunctionality", MS.UIRootPrefabFunctionality)

function LevelEndFunctionality:Init()
    local mainPanel = self.owner.bindingUI.MainPanel
    local returnButton = mainPanel.ReturnButton

    returnButton.Click:Connect(
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

function LevelEndFunctionality:Update(eventName, ...)
    if eventName == "OnLevelEnd" then
        local win = select(1, ...)
        if win then
            self.owner.bindingUI.MainPanel.Title.Icon = "sandboxId://PVZ_Icon/Background/ActionText_Victory.png"
            self.owner.bindingUI.MainPanel.Title.Tips.Icon =
                "sandboxId://PVZ_UI/PlayerHUD/Img_Battle_Jiesuan_Victory.png"
            self.owner.bindingUI.MainPanel.Title.Dec.Icon =
                "sandboxId://PVZ_UI/PlayerHUD/Bg_Battle_Jiesuan_VictoryDec01.png"
        else
            self.owner.bindingUI.MainPanel.Title.Icon = ""
            self.owner.bindingUI.MainPanel.Title.Tips.Icon =
                "sandboxId://PVZ_UI/PlayerHUD/Img_Battle_Jiesuan_Defeat.png"
            self.owner.bindingUI.MainPanel.Title.Dec.Icon =
                "sandboxId://PVZ_UI/PlayerHUD/Bg_Battle_Jiesuan_DefeatDec01.png"
        end
    end
end

return LevelEndFunctionality
