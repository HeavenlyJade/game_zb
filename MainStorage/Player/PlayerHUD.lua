local PlayerHUD = MS.Class.new("PlayerHUD")

function PlayerHUD:ctor()
    self.uiRoots = {}
    self.eventObject = MS.EventObject.new()
    self.eventNames = {}
end

function PlayerHUD:Init()
    self.eventNames = MS.Utils.DeepCopy(_G.PlayerController.eventNames)
    self:RegisterEvents()
end

function PlayerHUD:CreateUIRoot(prefabName, instanceName, Parent)
    local rootPrefab = MS.UIRootPrefab:FindFirstChild(prefabName)

    local uiRoot = nil
    if rootPrefab ~= nil then
        uiRoot = MS.UIRoot.new()
        uiRoot:Init(rootPrefab)
        uiRoot.bindingUI.Parent = Parent
        uiRoot.bindingUI.Name = instanceName
        self.uiRoots[instanceName] = uiRoot
    end
    return uiRoot
end

function PlayerHUD:SetUIRootVisibility(UIName, Visible)
    if self.uiRoots[UIName] ~= nil then
        self.uiRoots[UIName].bindingUI.Visible = Visible
    end
end

function PlayerHUD:DestroyUIRoot(UIName)
    if self.uiRoots[UIName] ~= nil then
        self.uiRoots[UIName]:Destroy()
        self.uiRoots[UIName] = nil
    end
end

function PlayerHUD:RegisterEvents()
    -- 监听事件
    for _, eventName in pairs(self.eventNames) do
        self.eventObject:On(
            eventName,
            function(...)
                self:Update(eventName, ...)
            end
        )
    end
end

function PlayerHUD:Update(eventName, ...)
    for _, UIRoot in pairs(self.uiRoots) do
        UIRoot:Update(eventName, ...)
    end
end

return PlayerHUD
