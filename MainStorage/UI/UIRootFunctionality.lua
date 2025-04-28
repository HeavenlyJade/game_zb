local UIRootFunctionality = MS.Class.new("UIRootFunctionality")

function UIRootFunctionality:ctor(owner)
    self.owner = owner
end

function UIRootFunctionality:Update(eventName, ...)
end

function UIRootFunctionality:Init(playerController)
    self.playerController = playerController
end

return UIRootFunctionality
