local ActorManager = MS.Class.new("ActorManager")

function ActorManager:ctor()
    self.plants = {}
end

function ActorManager:Init()
    self.ActorPrefabs = {
        -- Plants
        ShooterPlant = {
            actorType = "ShooterPlant",
            -- Components(Need to be Initialized)
            ActorComponents = {
                "SpawnComponent"
            },
            -- AIControllerBehavior
            AIControllerBehavior = {
                Idle = function(AIController)
                    -- local zombieUids = {}
                    -- for uid, zombieInstance in pairs(_G.GameMode.levelManager.currentLevel.levelState.zombieInstances) do
                    --     if zombieInstance == 1 then
                    --         table.insert(zombieUids, uid)
                    --         if #zombieUids > 0 then
                    --             local randomIndex = math.random(1, #zombieUids)
                    --             local selectedUid = zombieUids[randomIndex]
                    --             AIController.targetInstance = self:GetActorByUid(selectedUid)
                    --             AIController:SwitchState(AIController.StateEnum.Attack)
                    --         end
                    --     end
                    -- end
                end,
                Attack = function(AIController, targetInstance)
                    -- if targetInstance == nil then
                    --     AIController:SwitchState(AIController.StateEnum.Idle)
                    --     return
                    -- end
                    -- -- 转向僵尸的方向
                    -- AIController.pawn.bindActor:LookAt(targetInstance.bindActor.Position, true)
                    -- -- 朝僵尸的方向进行射击
                    -- if MS.GameMode.GameState.zombieInstances[targetInstance.uid] == 0 then
                    --     AIController.pawn:ReleaseTrigger()
                    --     AIController:SwitchState(AIController.StateEnum.Idle)
                    -- else
                    --     if AIController.pawn.pullingTrigger == false then
                    --         AIController.pawn:PullTrigger()
                    --     end
                    -- end
                end,
                Die = function(AIController)
                    -- AIController.pawn.bindActor.EnablePhysics = false
                    -- ZombieMgr.ZombieNormalDead(AIController.pawn.bindActor)
                    -- -- AIController.pawn.actorComponents["AnimComponent"].animator:Play("Base.Die", 0, 0)
                    -- AIController.isDead = true
                    -- -- 检查所有植物是否都已死亡
                    -- local allPlantsDead = true
                    -- for _, plantInstance in pairs(_G.GameMode.levelManager.currentLevel.levelState.weaponPlantInstances) do
                    --     if not plantInstance.actorComponents["AIController"].isDead then
                    --         allPlantsDead = false
                    --         break
                    --     end
                    -- end
                    -- -- 如果所有植物都死亡，结束游戏
                    -- if allPlantsDead then
                    --     _G.GameMode.levelManager.currentLevel:EndLevel(false)
                    -- end
                end
            }
        }
    }
end

-- Actor Management
function ActorManager:SpawnActor(ActorName, Parent, LocalPosition, LocalEuler)
    local configNode = MS.Config.GetCustomConfigNode(ActorName)
    local ActorClass = configNode.ClassNode.Name

    local plantNode = configNode.Model:Clone()

    plantNode.Name = ActorName
    plantNode.Parent = Parent
    plantNode.LocalPosition = LocalPosition
    plantNode.LocalEuler = LocalEuler
    plantNode.CollideGroupID = 2

    -- fix muzzle light bug
    local muzzleFlash = plantNode.FirePosition:FindFirstChild("MuzzleFlash")
    if muzzleFlash then
        muzzleFlash.Active = true
        muzzleFlash.LightType = Enum.LightType.UnKnow
        muzzleFlash.LightType = Enum.LightType.Point
        muzzleFlash.Active = false
    end

    return self:CreateActor(plantNode, ActorClass, ActorName, plantNode.ID)
end

function ActorManager:RemoveActor(Actor)
    local uid = Actor.bindActor.ID
    self:DestroyActorByUid(uid)
end

function ActorManager:CreateActor(bindObj, actorClass, actorPrefabName, uid)
    local configNode = MS.Config.GetCustomConfigNode(actorPrefabName)
    local configData = require(configNode.Data)
    for _, prefab in pairs(self.ActorPrefabs) do
        if prefab.actorType == configData.actorType then
            local actor = MS.ActorBase.new(bindObj, actorClass, uid)

            for _, componentName in ipairs(prefab.ActorComponents) do
                local componentClass = require(MS.MainStorage.Actor.ActorComponent:WaitForChild(componentName))
                local component = componentClass.new(actor)
                actor.actorComponents[componentName] = component
            end
            -- Init Components
            if actor.actorComponents["SpawnComponent"] ~= nil then
                local component = actor:GetComponent("SpawnComponent")
                component:Init()
            end
            self.plants[actor.bindActor.ID] = actor
            return actor
        end
    end
end

function ActorManager:GetActorByUid(uid)
    return self.plants[uid] or nil
end

function ActorManager:DestroyActorByUid(uid)
    local actor = self:GetActorByUid(uid)
    if actor ~= nil then
        actor.bindActor:Destroy()
        self.plants[uid] = nil
    end
end

return ActorManager
