local ActorComponent = MS.Class.new("ActorComponent")
-- 实例化
function ActorComponent:ctor(owner)
    self.owner = owner

    self.updateEnabled = false
    self.fixedUpdateRate = 0
end

function ActorComponent:dtor()
    self:OnDestroy()
end

function ActorComponent:SetOwner(owner)
    self.owner = owner
end

function ActorComponent:GetOwner()
    return self.owner
end

function ActorComponent:Init(Owner)
    self:SetOwner(Owner)
end

return ActorComponent
