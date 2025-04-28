local LevelMenuFunctionality = MS.Class.new("LevelMenuFunctionality", MS.UIRootPrefabFunctionality)

function LevelMenuFunctionality:Init()
    local mainPanel = self.owner.bindingUI.MainPanel
    local LevelList = mainPanel.LevelListBG.LevelList
    for i = 1, 5 do
        local levelSlot = _G.PlayerController.playerHUD:CreateUIRoot("LevelSlot", "LevelSlot" .. i, LevelList)

        -- 暂时的特殊处理
        if i == 1 then
            levelSlot.bindingUI.LockBG.Visible = false
            levelSlot.bindingUI.Level.Stars.Visible = true
            levelSlot.bindingUI.LevelProgress.FirstProgressBar.Visible = true
        end

        if i == 5 then
            levelSlot.bindingUI.LevelProgress.LevelProgressBar.Visible = false
        end

        levelSlot.bindingUI.LevelProgress.CheckPoint.LevelNum.Title = "0" .. i
        -- 特殊处理End

        levelSlot.bindingUI.Level.Click:Connect(
            function()
                if MS.MainStorage.Level.LevelPrefab["Level" .. i] == nil then
                    return
                end

                _G.PlayerController.eventObject:FireEvent("OnSelectLevelEnd")
                _G.GameMode.levelManager.eventObject:FireEvent("OnSwitchLevel", "Level" .. i)
                _G.PlayerController.eventObject:FireEvent("OnLevelPrepareStart")
            end
        )

        levelSlot.bindingUI.LevelProgress.CheckPoint.TouchBegin:Connect(
            function()
                if MS.MainStorage.Level.LevelPrefab["Level" .. i] == nil then
                    return
                end

                _G.PlayerController.eventObject:FireEvent("OnSelectLevelEnd")
                _G.GameMode.levelManager.eventObject:FireEvent("OnSwitchLevel", "Level" .. i)
                _G.PlayerController.eventObject:FireEvent("OnLevelPrepareStart")
            end
        )
    end

    local exitButton = mainPanel.Exit
    exitButton.TouchBegin:Connect(
        function()
            _G.PlayerController.eventObject:FireEvent("OnExitLevelMenu")
        end
    )
end

function LevelMenuFunctionality:Update(eventName, ...)
end

return LevelMenuFunctionality
