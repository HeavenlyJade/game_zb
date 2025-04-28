local PostProcessing = MS.Class.new("PostProcessing")

function PostProcessing:ctor()
    self.node = nil
end

function PostProcessing:Init()
    self.node = MS.Environment.PostProcessing
end

--启动客户端
function PostProcessing:StartClient()

end

-- function PostProcessing:OnSceneSet(scene)
--     if not self:IsServer() and scene then
--         local env = scene:GetEnvironment()
--         if env then
--             self.bindObj = env.PostProcessing
--         else
--             Log:Error("PostProcessing:OnSceneSet() env is nil")
--         end
--     end
-- end

--启用色差
function PostProcessing:EnableChromaticAberration(enable)
    if not self.node then
        return 0
    end
    self.node.ChromaticAberrationActive = enable
end

--设置色差强度
function PostProcessing:SetChromaticAberrationIntensity(intensity)
    if not self.node then
        return 0
    end
    self.node.ChromaticAberrationIntensity = intensity
end

--获取色差强度
function PostProcessing:GetChromaticAberrationIntensity()
    if not self.node then
        return 0
    end
    return self.node.ChromaticAberrationIntensity
end


--设置色差开始偏移
function PostProcessing:SetChromaticAberrationStartOffset(value)
    if not self.node then
        return 0
    end
    self.node.ChromaticAberrationStartOffset = value
end

--获取色差开始偏移
function PostProcessing:GetChromaticAberrationStartOffset()
    if not self.node then
        return 0
    end
    return self.node.ChromaticAberrationStartOffset
end

--设置色差迭代
function PostProcessing:SetChromaticAberrationIterationStep(value)
    if not self.node then
        return 0
    end
    self.node.ChromaticAberrationIterationStep = value
end

--获取色差迭代
function PostProcessing:GetChromaticAberrationIterationStep()
    if not self.node then
        return 0
    end
    return self.node.ChromaticAberrationIterationStep
end

--设置色差迭代采样
function PostProcessing:SetChromaticAberrationIterationSamples(value)
    if not self.node then
        return 0
    end
    self.node.ChromaticAberrationIterationSamples = value
end

--获取色差迭代采样
function PostProcessing:GetChromaticAberrationIterationSamples()
    if not self.node then
        return 0
    end
    return self.node.ChromaticAberrationIterationSamples
end


return PostProcessing