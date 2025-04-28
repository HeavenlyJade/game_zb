local LevelManager = MS.Class.new("LevelManager")

function LevelManager:ctor()
    self.eventObject = MS.EventObject.new()
    self.eventNames = {
        "OnSwitchLevel",
        "OnLevelStart",
        "OnLevelEnd"
    }
    self.currentLevel = nil
    self.currentLevelName = ""
end

function LevelManager:Init()
    self:RegisterEvents()
end

function LevelManager:SwitchLevel(LevelName)
    self:RemoveCurrentLevel()
    self:LoadLevel(LevelName)
end

function LevelManager:RemoveCurrentLevel()
    if self.currentLevel ~= nil then
        self.currentLevel:Destroy()
        self.currentLevel = nil
    end
end

function LevelManager:LoadLevel(LevelName)
    self.currentLevelName = LevelName
    self.currentLevel = MS.Level.new()
    self.currentLevel:Init(self.currentLevelName)
end

function LevelManager:RegisterEvents()
    for _, eventName in pairs(self.eventNames) do
        self.eventObject:On(
            eventName,
            function(...)
                self:Update(eventName, ...)
            end
        )
    end
end

function LevelManager:Update(eventName, ...)
    if eventName == "OnSwitchLevel" then
        local levelName = select(1, ...)
        self:SwitchLevel(levelName)
    elseif eventName == "OnLevelStart" then
        self.currentLevel:StartLevel()
    elseif eventName == "OnLevelEnd" then
        local win = select(1, ...)
        self.currentLevel:EndLevel(win)
    end
end

return LevelManager
