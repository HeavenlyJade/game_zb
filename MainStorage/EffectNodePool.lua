local EffectNodePool = {
    effectNodePoolReady = {}
}

function EffectNodePool:Init()
    local EffectPool = SandboxNode.new("Transform", MS.WorkSpace)
    EffectPool.Name = "EffectPool"
    for i = 1, 50 do
        local effectNode = SandboxNode.new("EffectObject", EffectPool)
        effectNode.Name = "EffectNode" .. i
        effectNode.Visible = false
        effectNode:Pause()
        table.insert(self.effectNodePoolReady, effectNode)
    end
end

function EffectNodePool:ActivateEffectNode(effectAssetID, parent, localPosition, localEuler, localScale)
    local effectNode = self.effectNodePoolReady[1]
    if effectNode == nil then
        print("nil")
        return
    end

    effectNode.AssetID = effectAssetID
    effectNode.Visible = true

    effectNode.Parent = parent
    effectNode.LocalPosition = localPosition
    effectNode.LocalEuler = localEuler
    effectNode.LocalScale = localScale

    effectNode:ReStart()

    table.remove(self.effectNodePoolReady, 1)
    table.insert(self.effectNodePoolReady, effectNode)
end

return EffectNodePool
