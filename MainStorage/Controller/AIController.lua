local AIController = MS.Class.new("AIController", MS.Controller)

AIController.StateEnum = {
    Idle = 1,
    Move = 2,
    Attack = 3,
    Die = 4
}

function AIController:ctor()
    self.updateEnabled = true
    self.preState = self.StateEnum.Idle
    self.currentState = self.StateEnum.Idle
    self.AIBehaviors = {}
    self.targetInstance = nil

    self.isDead = false
end

function AIController:InitBehavior(AIBehaviors)
    self.AIBehaviors = MS.Utils.DeepCopy(AIBehaviors)
end

function AIController:Init(AIBehavior, UpdateRate)
    self.randX = math.random() * 100 - 50
    self.randZ = math.random() * 100 - 50

    self:InitBehavior(AIBehavior)

    self.fixedUpdateRate = UpdateRate
    MS.Timer.CreateTimer(
        self.fixedUpdateRate,
        self.fixedUpdateRate,
        true,
        function()
            self:Update()
        end
    ):Start()
    self:SwitchState(self.StateEnum.Idle)
end

function AIController:Update()
    if self.updateEnabled then
        self:Act()
    end
end

function AIController:StopUpdate()
    self.updateEnabled = false
end

function AIController:Act()
    if self.currentState == AIController.StateEnum.Idle then
        self.AIBehaviors.Idle(self)
    elseif self.currentState == AIController.StateEnum.Attack then
        self.AIBehaviors.Attack(self, self.targetInstance)
    end
end

function AIController:SwitchState(state)
    self.preState = self.currentState
    if self.currentState ~= state then
        self.currentState = state
        self:Update()
    end
end

return AIController
