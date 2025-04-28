local UIRoot = MS.Class.new("UIRoot")

function UIRoot:ctor()
    self.bindingUI = nil
    self.bindingFunctionality = nil
end

function UIRoot:Init(UIRootPrefab)
    self:SetBindingUI(UIRootPrefab)
    self:SetBindingFunc(UIRootPrefab)
end

function UIRoot:SetBindingUI(UIRootPrefab)
    self.bindingUI = UIRootPrefab:Clone()
end

function UIRoot:SetBindingFunc(UIRootPrefab)
    local UIFunctionality = MS.UIRootPrefabFunctionality:FindFirstChild(UIRootPrefab.Name)
    local functionalityModule = require(UIFunctionality)
    self.bindingFunctionality = functionalityModule.new()
    self.bindingFunctionality.owner = self
    self.bindingFunctionality:Init()
end

function UIRoot:Update(eventName, ...)
    self.bindingFunctionality:Update(eventName, ...)
end

function UIRoot:Destroy()
    if self.bindingUI ~= nil then
        self.bindingUI:Destroy()
        self.bindingUI = nil
    end
    if self.bindingFunctionality ~= nil then
        self.bindingFunctionality = nil
    end
end

return UIRoot
