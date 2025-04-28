local LobbyFunctionality = MS.Class.new("LobbyFunctionality", MS.UIRootPrefabFunctionality)

function LobbyFunctionality:Init()
    local rightBottom = self.owner.bindingUI.RightBottom.Bottom
    rightBottom.TouchBegin:Connect(
        function()
            _G.PlayerController.eventObject:FireEvent("OnEnterLevelMenu")
        end
    )

    local exitButton = self.owner.bindingUI.RightTop.Exit
    exitButton.TouchBegin:Connect(
        function()
            print("send Tp Request")
            local playerId = MS.Players.LocalPlayer.UserId
            MS.Bridge.SendMessageToServer(
                MS.Protocol.ClientMsgID.TELEPORT_REQUEST,
                {playerId = playerId, mapId = 12839541415348}
            )
        end
    )

    self.owner.bindingUI.RightTop.Setting.Click:Connect(function()
        game:GetService("CoreUI"):ShowSettingButton()
        print("open setting btn1")
    end)
    
end

function LobbyFunctionality:Update(eventName, ...)
end

return LobbyFunctionality
