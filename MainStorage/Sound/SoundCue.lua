local SoundCue = MS.Class.new("SoundCue")

function SoundCue:ctor(soundGroup)
    self.soundGroup = soundGroup
end

function SoundCue:Init()
end

function SoundCue:GetSounds()
    -- 给每个sound添加isPlaying属性
    for _, sound in ipairs(self.soundGroup.Children) do
        sound:AddAttribute("isPlaying", Enum.AttributeType.Bool)
        sound:SetAttribute("isPlaying", false)
    end
    return self.soundGroup.Children
end

function SoundCue:GetSound(name)
    return self.soundGroup:FindFirstChild(name)
end

function SoundCue:RandomPlaySound()
    local sounds = self:GetSounds()
    local randomSound = sounds[math.random(1, #sounds)]
    self:Play(randomSound)
end

function SoundCue:GetShootSound(name)
    return self.soundGroup.ShootSoundNode:FindFirstChild(name)
end

function SoundCue:PlayShootSound()
    if self.soundGroup.ShootSoundNode == nil then
        return
    end
    local shootSoundCount = #self.soundGroup.ShootSoundNode.Children

    -- 记录当前播放的音效索引
    if not self.currentShootSoundIndex then
        self.currentShootSoundIndex = 1
    end

    -- 播放当前索引的音效
    if self.soundGroup.ShootSoundNode.Children[self.currentShootSoundIndex] then
        self.soundGroup.ShootSoundNode.Children[self.currentShootSoundIndex]:ResumeSound()
    end

    -- 更新索引，实现循环
    self.currentShootSoundIndex = self.currentShootSoundIndex + 1
    if self.currentShootSoundIndex > shootSoundCount then
        self.currentShootSoundIndex = 1
    end
end

function SoundCue:PlayReloadSound()
    self:Play(self:GetSound("ReloadSound"))
end

function SoundCue:Play(sound)
    sound:SetAttribute("isPlaying", true)
    sound:ResumeSound()

    sound.PlayFinish:Connect(
        function()
            sound:SetAttribute("isPlaying", false)
        end
    )
end

function SoundCue:Stop(sound)
    sound:SetAttribute("isPlaying", false)
    sound:StopSound()
end

return SoundCue
