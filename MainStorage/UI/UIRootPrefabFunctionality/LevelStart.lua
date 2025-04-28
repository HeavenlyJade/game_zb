local LevelStart = MS.Class.new("LevelStart", MS.UIRootPrefabFunctionality)

function LevelStart:Init()
    self.mainPanel = self.owner.bindingUI.MainPanel
    self.countDown = self.mainPanel:FindFirstChild("CountDown")
end

function LevelStart:Update(eventName, ...)
    if eventName == "OnCountDown" then
        local count = ...
        coroutine.work(function()
            self.countDown.Visible = true
            for i = count, 1, -1 do
                self.countDown.Scale = Vector2.New(2, 2)
                self.countDown.Icon = "sandboxId://PVZ_UI/PlayerHUD/Countdown/Img_CtD_" .. i .. ".png"
                --用tween实现icon从大变小
                local goal = {
                    Scale = Vector2.New(1, 1)
                }
                local tween = MS.Tween.CreateTween(self.countDown, goal, 0.5)
                tween:Play()
                wait(1)
                tween:Destroy()
            end
            self.countDown.Visible = false
        end)
    end
end

return LevelStart
