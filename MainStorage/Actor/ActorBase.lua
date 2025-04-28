local ActorBase = MS.Class.new("ActorBase")

function ActorBase:ctor(ActorObject, ActorClassName, Uid)
    self.uid = Uid -- 0 means uninitialized
    -- Property
    self.bindActor = nil
    self.bindTween = nil
    self.actorClass = ActorClassName

    self.eventObject = MS.EventObject.new()

    self.actorComponents = {}

    self:SetBindActor(ActorObject)
end

function ActorBase:SetBindActor(ActorObject)
    self.bindActor = ActorObject
end

function ActorBase:GetComponent(componentType)
    return self.actorComponents[componentType]
end

function ActorBase:AddComponent(componentType, component)
    self.actorComponents[componentType] = component
end
return ActorBase
