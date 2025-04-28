local SoundNodePool = {
    soundNodePoolReady = {}
}

function SoundNodePool:Init()
    local SoundPool = SandboxNode.new("Transform", MS.WorkSpace)
    SoundPool.Name = "SoundPool"
    for i = 1, 50 do
        local soundNode = SandboxNode.new("Sound", SoundPool)
        soundNode.Name = "SoundNode" .. i
        table.insert(self.soundNodePoolReady, soundNode)
    end
end

function SoundNodePool:ActivateSoundNode(soundAssetID, parent, localPosition)
    local soundNode = self.soundNodePoolReady[1]
    if soundNode == nil then
        print("nil")
        return
    end

    soundNode.SoundPath = soundAssetID
    soundNode.Parent = parent
    soundNode.FixPos = localPosition
    soundNode.Volume = 100

    soundNode:PlaySound()

    table.remove(self.soundNodePoolReady, 1)
    table.insert(self.soundNodePoolReady, soundNode)
end

return SoundNodePool
