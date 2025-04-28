local RunService = game:GetService("RunService")
local M = {}
-- all zombie functions but not container function

M.Type_Normal = 1
M.Type_Barricade = 2
M.Type_Bucket= 3

M.SupportPrefabs = {
    {['name'] = 'NormalZombie', ['type'] = M.Type_Normal},
    {['name'] = 'BarricadeZombie', ['type'] = M.Type_Barricade},
    {['name'] = 'BucketZombie', ['type'] = M.Type_Bucket},
}


M.AnimatorId_Idle1 = 101
M.AnimatorId_Idle2 = 102
M.AnimatorId_Idle3 = 103
M.AnimatorId_Walk1 = 104
M.AnimatorId_CrawlSlow = 105
M.AnimatorId_CrawlFast = 120
-- M.AnimatorId_SitIdle = 106
M.AnimatorId_Run1 = 107         -- 慢跑
M.AnimatorId_Run2 = 108         -- 快跑
-- M.AnimatorId_CrawFast = 109
M.AnimatorId_StandUp1 = 110     -- 站起来
-- M.AnimatorId_StandUp2 = 111
M.AnimatorId_JumpLittle = 119
M.AnimatorId_JumpHeavy = 112
-- M.AnimatorId_FallingAir = 113
-- M.AnimatorId_FollonGround = 114
-- M.AnimatorId_FallingHigh1 = 115
-- M.AnimatorId_FallingHigh2 = 116
M.AnimatorId_FallingHigh2Start = 130
M.AnimatorId_FallingHigh2Loop = 131
M.AnimatorId_FallingHigh2End = 132
M.AnimatorId_FallingHigh1Start = 133
M.AnimatorId_FallingHigh1Loop = 134
M.AnimatorId_FallingHigh1End = 135
-- M.AnimatorId_Falling1 = 136
-- M.AnimatorId_Falling2 = 137
M.AnimatorId_Climb = 117
M.AnimatorId_ClimbEnd = 118


M.AnimatorId_Attack1 = 201
M.AnimatorId_Attack2= 202
-- M.AnimatorId_JumpATK1= 203

-- M.AnimatorId_Hit1= 401
-- M.AnimatorId_Hit2 = 402
M.AnimatorId_DieFlyLeft = 403
M.AnimatorId_DieFlyRight = 404
M.AnimatorId_DieFlyFront = 405
M.AnimatorId_DieFlyBack = 406
M.AnimatorId_DieHS = 407            -- HeadShoot
M.AnimatorId_DieClimb = 409         -- 正常死亡
M.AnimatorId_DieCrawl = 410         -- 爬行死亡
M.AnimatorId_Falling1 = 411         --1/2 CLimb Die
M.AnimatorId_Falling2 = 412
M.AnimatorId_DieExploded = 413      -- 变成碎片
M.AnimatorId_DieL = 414             --正常死亡
M.AnimatorId_DieR = 415
M.AnimatorId_Die1 = 416             
M.AnimatorId_Die2 = 417
M.AnimatorId_DieArm = 408           -- 断胳膊

M.AnimatorGroup_Base = 1
M.AnimatorGroup_Attack = 2
M.AnimatorGroup_Skill = 3
M.AnimatorGroup_BeAttack = 4

--[]
M.AnimatorNodeDelayActionMap = {}
M.IgnoreResetAnimatorStatus = false

M.AniamtorIDCount = 0
function M.GenNodeAnimatorId()
    M.AniamtorIDCount = M.AniamtorIDCount + 1
    return M.AniamtorIDCount
end

function M.RemoveNodeDelayActions(node)
    for i = #M.AnimatorNodeDelayActionMap, 1, -1 do
        if M.AnimatorNodeDelayActionMap[i][1] == node then
            table.remove(M.AnimatorNodeDelayActionMap, i)
        end
    end
end

function M.AddNodeDelayActions(node, delayMS, func, params)
    delayMS = delayMS + RunService:CurrentMilliSecondTimeStamp()
    M.AnimatorNodeDelayActionMap[#M.AnimatorNodeDelayActionMap+1] = {node, delayMS, func, params}
    M.AddUpdateListener()
end


function M.CheckAllDelayActions()
    M.IgnoreResetAnimatorStatus = true
    local curMs = RunService:CurrentMilliSecondTimeStamp()
    for i = #M.AnimatorNodeDelayActionMap, 1, -1 do
        local delayTab = M.AnimatorNodeDelayActionMap[i]
        local delayMS = delayTab[2]
        if curMs > delayMS then
            delayTab[3](unpack(delayTab[4]))
            table.remove(M.AnimatorNodeDelayActionMap, i)
        end
    end
    M.IgnoreResetAnimatorStatus = false
end



M.AnimatorStates = {
    {['id'] = M.AnimatorId_Idle1, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Idle1"},
    {['id'] = M.AnimatorId_Idle2, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Idle2"},
    {['id'] = M.AnimatorId_Idle3, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Idle3"},
    {['id'] = M.AnimatorId_Walk1, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Walk1"},
    {['id'] = M.AnimatorId_CrawlSlow, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.CrawlSlow"},
    {['id'] = M.AnimatorId_CrawlFast, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.CrawlFast"},
    -- {['id'] = M.AnimatorId_SitIdle, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.SitIdle"},
    {['id'] = M.AnimatorId_Run1, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Run1"},
    {['id'] = M.AnimatorId_Run2, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Run2"},
    -- {['id'] = M.AnimatorId_CrawFast, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.CrawFast"},
    {['id'] = M.AnimatorId_StandUp1, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.StandUp"},
    -- {['id'] = M.AnimatorId_StandUp2, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.StandUp"},
    {['id'] = M.AnimatorId_JumpLittle, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.JumpLittle"},
    {['id'] = M.AnimatorId_JumpHeavy, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.JumpHeavy"},
    -- {['id'] = M.AnimatorId_FallingAir, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.FallingAir"},
    -- {['id'] = M.AnimatorId_FollonGround, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.FollonGround"},
    -- {['id'] = M.AnimatorId_FallingHigh1, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.FallingHigh1"},
    -- {['id'] = M.AnimatorId_FallingHigh2, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.FallingHigh2"},
    {['id'] = M.AnimatorId_FallingHigh2Start, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.FallingHigh2Start"},
    {['id'] = M.AnimatorId_FallingHigh2Loop, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.FallingHigh2Loop"},
    {['id'] = M.AnimatorId_FallingHigh2End, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.FallingHigh2End"},
    {['id'] = M.AnimatorId_FallingHigh1Start, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.FallingHigh1Start"},
    {['id'] = M.AnimatorId_FallingHigh1Loop, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.FallingHigh1Loop"},
    {['id'] = M.AnimatorId_FallingHigh1End, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.FallingHigh1End"},
    -- {['id'] = M.AnimatorId_Falling1, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Falling1"},
    -- {['id'] = M.AnimatorId_Falling2, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Falling2"},

    {['id'] = M.AnimatorId_Climb, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Climbing"},
    {['id'] = M.AnimatorId_ClimbEnd, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.ClimbEnd"},

    {['id'] = M.AnimatorId_Attack1, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Atk1"},
    {['id'] = M.AnimatorId_Attack2, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.ATK2"},
    -- {['id'] = M.AnimatorId_JumpATK1, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.ATK2"},

    -- {['id'] = M.AnimatorId_Hit1, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Hit1"},
    -- {['id'] = M.AnimatorId_Hit2, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Hit2"},
    {['id'] = M.AnimatorId_DieFlyLeft, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.DieFlyLeft"},
    {['id'] = M.AnimatorId_DieFlyRight, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.DieFlyRight"},
    {['id'] = M.AnimatorId_DieFlyFront, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.DieFlyFront"},
    {['id'] = M.AnimatorId_DieFlyBack, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.DieFlyBack"},
    {['id'] = M.AnimatorId_DieHS, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.DieHS"},
    {['id'] = M.AnimatorId_DieArm, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.DieArm"},
    {['id'] = M.AnimatorId_DieClimb, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.DieClimb"},
    {['id'] = M.AnimatorId_DieCrawl, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.DieCrawl"},
    {['id'] = M.AnimatorId_Falling1, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Falling1"},
    {['id'] = M.AnimatorId_Falling2, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Falling2"},
    {['id'] = M.AnimatorId_DieExploded, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.DieExploded"},
    {['id'] = M.AnimatorId_DieL, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.DieL"},
    {['id'] = M.AnimatorId_DieR, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.DieR"},
    {['id'] = M.AnimatorId_Die1, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Die1"},
    {['id'] = M.AnimatorId_Die2, ['layerIdx'] = 0, ['stateName'] = "BaseLayer.Die2"},
}


function M.Init()
    M.idConfigs = {}
    M.nameTypeMap = {}
    M.typeNameMap = {}
    M.removeZombies = {}
    for i,item in ipairs(M.AnimatorStates) do
        local id = item.id
        M.idConfigs[id] = item
    end
    for i, item in ipairs(M.SupportPrefabs) do
        local itemName = item['name']
        local itemType = item['type']
        local genId = ObjectPool.GenNodeTypeId()
        local prefabNode = MS.Config.GetCustomConfigNode(itemName).Model
        ObjectPool.RegisterType(genId, prefabNode)
        M.nameTypeMap[itemName] = {itemType, genId}
        M.typeNameMap[itemType] = itemName
    end
end

function M.GetConfigByAnimatorId(animatorId)
    return M.idConfigs[animatorId]
end

function M.CreateZombieByName(name)
    local itemConfig = M.nameTypeMap[name]
    if itemConfig == nil then
        print("fatal error please check name ", name)
    end
    return ObjectPool.GetObject(itemConfig[2])
end

function M.CreateZombie(typeId)
    local name = M.typeNameMap[typeId]
    if name == nil then
        print("fatal error please check type id")
    end
    local zombie = M.CreateZombieByName(name)
    M.ZombieSpawn(zombie)
    return zombie
end

function M.PlayAnimator(zombie, animatorId)
    local config = M.GetConfigByAnimatorId(animatorId)
    if config == nil then
        print("fatal error cannot found animatorId ", animatorId)
    end
--    print(zombie, config.stateName)
    zombie.Animator:Play(config.stateName, config.layerIdx, 0)
    if not M.IgnoreResetAnimatorStatus then
        -- 开启新动画，之前的延迟动画全部取消，状态已经失效
        M.RemoveNodeDelayActions(zombie)
    end
end

function M.ZombieSpawn(zombie)
    local candidates = {M.AnimatorId_StandUp1}
    local animatorId = candidates[math.random(1, #candidates)]
    M.PlayAnimator(zombie, animatorId)
end

function M.ZombieIdle(zombie, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_Idle1, M.AnimatorId_Idle2, M.AnimatorId_Idle3}
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.PlayAnimator(zombie, animatorId)
end

function M.ZombieWalk(zombie, isCrawl, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_Walk1}
        if isCrawl then
            candidates = {M.AnimatorId_CrawlSlow}
        end
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.PlayAnimator(zombie, animatorId)
end

function M.ZombieRun(zombie, isCrawl, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_Run1, M.AnimatorId_Run2}
        if isCrawl then
            candidates = {M.AnimatorId_CrawlFast}
        end
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.PlayAnimator(zombie, animatorId)
end

-- function M.ZombieSit(zombie, animatorId)
--     if animatorId == nil then
--         local candidates = {M.AnimatorId_SitIdle}
--         animatorId = candidates[math.random(1, #candidates)]
--     end
--     M.PlayAnimator(zombie, animatorId)
-- end

-- function M.ZombieStandUp(zombie, animatorId)
--     if animatorId == nil then
--         local candidates = {M.AnimatorId_StandUp1, M.AnimatorId_StandUp2}
--         animatorId = candidates[math.random(1, #candidates)]
--     end
--     M.PlayAnimator(zombie, animatorId)
-- end

function M.ZombieJump(zombie, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_JumpHeavy, M.AnimatorId_JumpLittle}
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.PlayAnimator(zombie, animatorId)
end

function M.ZombieFallStart(zombie, height, animatorId)
    -- 1 0.53  2.1
    -- 2 0.43  1.8
    -- print("maxll ", zombie, height, animatorId)
    local fallTime = math.sqrt(2 * height / 98)
    if animatorId == nil then
        animatorId = math.random(1, 2)
    end
    if animatorId == 1 then
        M.PlayAnimator(zombie,M.AnimatorId_FallingHigh1Start)
        local loopTime = fallTime - 0.53 - 2.1
        if loopTime > 0 then
            M.AddNodeDelayActions(zombie, 530, M.ZombiewFallEnd,{zombie, M.AnimatorId_FallingHigh1Loop})
        else
            loopTime = 0
        end
        M.AddNodeDelayActions(zombie, 530 + loopTime, M.ZombiewFallEnd,{zombie, M.AnimatorId_FallingHigh1End})
    elseif animatorId == 2 then
        M.PlayAnimator(zombie,M.AnimatorId_FallingHigh2Start)
        local loopTime = fallTime - 0.43 - 1.8
        if loopTime > 0 then
            M.AddNodeDelayActions(zombie, 430, M.ZombiewFallEnd,{zombie, M.AnimatorId_FallingHigh2Loop})
        else
            loopTime = 0
        end
        M.AddNodeDelayActions(zombie, 430 + loopTime, M.ZombiewFallEnd,{zombie, M.AnimatorId_FallingHigh2End})
    end
end

function M.ZombiewFallLoop(zombie, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_FallingHigh2Loop, M.AnimatorId_FallingHigh1Loop}
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.PlayAnimator(zombie, animatorId)
end

function M.ZombiewFallEnd(zombie, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_FallingHigh2End, M.AnimatorId_FallingHigh1End}
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.PlayAnimator(zombie, animatorId)
end

function M.ZombieClimb(zombie, animatorId, delayMS)
    if animatorId == nil then
        local candidates = {M.AnimatorId_Climb}
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.PlayAnimator(zombie, animatorId)
    if delayMS == nil then
        delayMS = 2000
    end
    M.AddNodeDelayActions(zombie, delayMS, M.ZombieClimbEnd,{zombie, M.AnimatorId_ClimbEnd})
end

function M.ZombieClimbEnd(zombie, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_ClimbEnd}
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.PlayAnimator(zombie, animatorId)
end

function M.ZombieAttack(zombie, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_Attack1, M.AnimatorId_Attack2}
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.PlayAnimator(zombie, animatorId)
end

-- function M.ZombieBeAttack(zombie, animatorId)
--     if animatorId == nil then
--         local candidates = {M.AnimatorId_Hit1, M.AnimatorId_Hit2}
--         animatorId = candidates[math.random(1, #candidates)]
--     end
--     M.PlayAnimator(zombie, animatorId)
-- end

function M.ZombieCommonDie(zombie, animatorId)
    M.PlayAnimator(zombie, animatorId)
    M.DelayRemove(zombie)
end

function M.ZombieBoomFly(zombie, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_DieFlyLeft, M.AnimatorId_DieFlyRight, M.AnimatorId_DieFlyFront,
        M.AnimatorId_DieFlyBack, M.AnimatorId_DieExploded}
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.ZombieCommonDie(zombie, animatorId)
end

function M.ZombieHeadShoot(zombie, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_DieHS}
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.ZombieCommonDie(zombie, animatorId)
end

function M.ZombieClimbDie(zombie, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_DieHS} 
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.ZombieCommonDie(zombie, animatorId)
end

function M.ZombiewFallDie(zombie, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_Falling1, M.AnimatorId_Falling2} 
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.ZombieCommonDie(zombie, animatorId)
end

function M.ZombieNormalDead(zombie, isCrawl, animatorId)
    if animatorId == nil then
        local candidates = {M.AnimatorId_DieL, M.AnimatorId_DieR, M.AnimatorId_Die1, M.AnimatorId_Die2, M.AnimatorId_DieArm}
        if isCrawl then
            candidates = {M.AnimatorId_DieCrawl}
        end
        animatorId = candidates[math.random(1, #candidates)]
    end
    M.ZombieCommonDie(zombie, animatorId)
end

function M.ZombieAllDieWithoutBoom(zombie, transferMode)
    -- print("maxll dead ", transferMode)
    if transferMode == nil then
        M.ZombieNormalDead(zombie, false)
    else
        if transferMode == "crawlslow" or transferMode == "crawlfast" then
            M.ZombieNormalDead(zombie, true)
        elseif transferMode == "climb" then
            M.ZombieClimbDie(zombie)
        elseif transferMode == "jump" then
            M.ZombiewFallDie(zombie)
        else
            M.ZombieNormalDead(zombie)
        end
    end
end

function M.DelayRemove(zombie, delayMS)
    local curMs = RunService:CurrentMilliSecondTimeStamp()
    if delayMS == nil then
        delayMS = math.random(1500, 2000)
    end
    delayMS = curMs + delayMS
    M.removeZombies[zombie] = delayMS
    M.AddUpdateListener()
end

function M.AddUpdateListener()
    if M.renderSteppedIns == nil then
        M.renderSteppedIns = RunService.RenderStepped:Connect(M.Update)
    end
end

function M.RemoveUpdateListener()
    if M.renderSteppedIns then
        M.renderSteppedIns:Disconnect()
        M.renderSteppedIns = nil
    end
end

function M.Update()
    local curMs = RunService:CurrentMilliSecondTimeStamp()
    local isEmpty = false
    local shouldRemoves = {}
    for zombie, delayMS in pairs(M.removeZombies) do
        if curMs >= delayMS then
            shouldRemoves[#shouldRemoves+1] = zombie
        else
            isEmpty = false
        end
    end
    for i,zombie in ipairs(shouldRemoves) do
        M.removeZombies[zombie] = nil
        M.Destroy(zombie)
    end
    M.CheckAllDelayActions()
    if #M.AnimatorNodeDelayActionMap > 0 then
        isEmpty = false
    end
    if isEmpty then
        M.RemoveUpdateListener()
    end
end


function M.Destroy(zombie)
    print("remove zombie", zombie)
    EffectManager.AddFrozenEffect(zombie, 1.0)
    zombie.Parent = nil
    return ObjectPool.RecycleObject(zombie)
end


return M