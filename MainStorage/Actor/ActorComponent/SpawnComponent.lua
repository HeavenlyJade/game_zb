local SpawnComponent = MS.Class.new("SpawnComponent", MS.ActorComponent)

local TIME_INTERVAL = 0.1

function SpawnComponent:ctor()
end

function SpawnComponent:Init()
end

function SpawnComponent:PerformTween(spawnActor, calcFunc, currentTime, spawnDamage)
    local spawnActorLifetime = 5
    local nextTime = currentTime + TIME_INTERVAL
    if nextTime >= spawnActorLifetime then
        -- TODO：超时的子弹仍然需要飞行最后一段距离
        spawnActor.spawner:RecycleBullet(spawnActor)
        return
    end

    local nextPosition = calcFunc(nextTime)
    local ret_list = self:DetectCollisionByLineTrace(spawnActor.bindActor.Position, nextPosition)
    for _, ret_table in pairs(ret_list) do
        -- TODO：撞击的子弹仍然需要飞行最后一段距离
        if spawnActor.bindActor.Name == "CherryBomb" then
            if ret_table.obj.CollideGroupID == 1 then
                EffectNodePool:ActivateEffectNode(
                    spawnActor.effectAssetID,
                    MS.WorkSpace,
                    spawnActor.bindActor.Position,
                    Vector3.New(0, 0, 0),
                    Vector3.New(2, 2, 2)
                )

                local zombies = {}
                MS.TargetUtils:SelectCylinderTargets(
                    spawnActor.bindActor.Position,
                    500,
                    500,
                    {3},
                    function(obj)
                        local zombie = ZManager.zombies[obj.ID]
                        if zombie then
                            local zombieHealth = ZManager:TakeDamage(zombie, spawnDamage)
                            if zombieHealth <= 0 then
                                zombies[#zombies + 1] = zombie.bindActor
                            end
                        end
                    end
                )

                for i, v in ipairs(zombies) do
                    print("zombie boom fly", v.ID)
                    ZombieMgr.ZombieBoomFly(v)
                end
                local ret =
                    EffectManager.AddExplosion(
                    spawnActor.bindActor.Position,
                    600,
                    zombies,
                    function(zombie)
                        -- ZombieMgr.ZombieBoomFly(zombie)
                    end
                )
                SoundNodePool:ActivateSoundNode(spawnActor.soundAssetID, MS.WorkSpace, spawnActor.bindActor.Position)
                _G.PlayerController.pawn.controlledWeaponPlantInstance:ApplyCameraShake("CherryBomb")
                spawnActor.spawner:RecycleBullet(spawnActor)
                return
            end
        else
            EffectNodePool:ActivateEffectNode(
                spawnActor.effectAssetID,
                MS.WorkSpace,
                spawnActor.bindActor.Position,
                Vector3.New(0, 0, 0),
                Vector3.New(1, 1, 1)
            )

            if ret_table.obj.CollideGroupID == 3 then
                local zombie = ZManager.zombies[ret_table.obj.ID]
                print("zombie's id", zombie.bindActor.ID)
                if zombie then
                    local zombieHealth = nil
                    if spawnActor.bindActor.Name == "Snowpea" then
                        zombieHealth = ZManager:TakeDamage(zombie, spawnDamage, "frozen")
                    elseif spawnActor.bindActor.Name == "Burningpea" then
                        zombieHealth = ZManager:TakeDamage(zombie, spawnDamage, "burning")
                    else
                        zombieHealth = ZManager:TakeDamage(zombie, spawnDamage, "")
                    end
                    print("zombie take damage", zombieHealth)

                    if zombieHealth <= 0 then
                        print("zombie play dead animation")
                        ZombieMgr.ZombieAllDieWithoutBoom(zombie.bindActor, zombie.transferMode)
                    end
                end
            end
            SoundNodePool:ActivateSoundNode(spawnActor.soundAssetID, MS.WorkSpace, spawnActor.bindActor.Position)
            spawnActor.spawner:RecycleBullet(spawnActor)
            return
        end
    end

    spawnActor.tween = MS.Tween.CreateTween(spawnActor.bindActor, {Position = nextPosition}, TIME_INTERVAL)
    spawnActor.tween.Completed:Connect(
        function()
            spawnActor.tween:Destroy()
            spawnActor.tween = nil
            self:PerformTween(spawnActor, calcFunc, nextTime, spawnDamage)
        end
    )
    spawnActor.tween:Play()
end

local function calcTime(tx, ty, speed, gravity)
    local t1 = speed * speed - gravity * ty
    local t2 = t1 * t1 - gravity * gravity * (tx * tx + ty * ty)
    if t2 < 0 then
        return nil
    end
    t2 = math.sqrt(t2)
    if t1 + t2 < 0 then
        return nil
    end
    if t1 - t2 < 0 then
        t2 = t1 + t2
    else
        t2 = t1 - t2
    end
    return math.sqrt(2 * t2) / gravity
end

local function calcVelocity(tx, ty, speed, gravity)
    local t = calcTime(tx, ty, speed, gravity)
    if t then
        return tx / t, ty / t + 0.5 * gravity * t, t
    end
    local s = math.sqrt(0.5) * speed
    return s, s, 0
end

function SpawnComponent:Spawn(spawnActor, targetPos, spawnSpeed, spawnDamage)
    local initPos = spawnActor.bindActor.Position
    local targetDir = targetPos - initPos
    local gravity = spawnActor.bindActor.Gravity
    local velocity
    if gravity <= 0 then
        Vector3.Normalize(targetDir)
        velocity = targetDir * spawnSpeed
        gravity = 0
    else
        local lx = math.sqrt(targetDir.X * targetDir.X + targetDir.Z * targetDir.Z)
        local ly = targetDir.Y
        local tx, ty, t = calcVelocity(lx, ly, spawnSpeed, gravity)
        local l = tx / lx
        velocity = Vector3.new(l * targetDir.X, ty, l * targetDir.Z)
    end

    local calcFunc = self:CalculateParabolicPath(initPos, velocity, gravity)
    self:PerformTween(spawnActor, calcFunc, 0, spawnDamage)
    return spawnActor
end

function SpawnComponent:CalculateParabolicPath(initialPosition, initialVelocity, gravity)
    -- 返回一个函数，该函数接受时间作为参数并返回位置
    return function(time)
        return initialPosition + initialVelocity * time - Vector3.new(0, gravity * time * time / 2, 0)
    end
end

function SpawnComponent:DetectCollisionByLineTrace(currentPosition, nextPosition)
    local spawnActorDirection = nextPosition - currentPosition
    local depth = spawnActorDirection.Length
    return MS.WorldService:RaycastAll(currentPosition, spawnActorDirection, depth, false, {1, 3})
end

return SpawnComponent
