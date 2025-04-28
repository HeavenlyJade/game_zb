local stateBase = {}

function stateBase.Define(stateName)
    local ret = {}
    setmetatable(ret, {__index = stateBase})
    ret.name = stateName
    ret.new = function(player, machine, layer)
        local stateObj = {}
        setmetatable(stateObj, {__index = ret})
        stateObj.player = player
        stateObj.machine = machine
        stateObj.layer = layer
        return stateObj
    end
    MS.StateMachine.stateDic[stateName] = ret
    return ret 
end

-- 设置状态
function stateBase:SetAction(actionState)
    self.player:SetAction(actionState)
end

-- 播放动画
function stateBase:PlayAnim(stateName, layer, normalized)
    self.player.animComp:Play(stateName, layer, normalized)
end

-- 渐变动画：淡入淡出动画
function stateBase:CrossFade(stateName, layer, transitionTotal, transitionOffset)
    self.player.animComp:CrossFade(stateName, layer, transitionTotal, transitionOffset)
end

-- 获取状态机Animator
function stateBase:GetAnimator()
    return self.player.animComp:GetAnimator()
end

-- 设置layer层级权重
function stateBase:SetLayerWeight(layer, weight)
    return self.player.animComp:SetLayerWeight(layer, weight)
end

-- 获取状态state
function stateBase:GetState(stateName, layerIdx, layerName)
    return self.player.animComp:GetState(stateName, layerIdx, layerName)
end

function stateBase:SwitchState(stateName, layer)
    if self.machine == nil or stateName == self.name then
        return
    end
    layer = layer or self.layer
    if layer == self.layer then
        self.isEnd = true
    end
    self.machine:SwitchState(stateName, layer)
end

------------------------------------------------ virsual functions
function stateBase:Start() end
function stateBase:LogicUpdate(dt) end
function stateBase:End() end

return stateBase