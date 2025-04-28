local Level = MS.Class.new("Level")

function Level:ctor()
    self.levelName = ""
    self.levelScript = nil
    self.levelPrefab = nil

    self.levelState = {
        zombieInstances = {},
        weaponPlantInstances = {},
        totalWaveCount = 0,
        currentWaveCount = 1,
        isLevelEnd = false
    }

    self.navigationMesh = nil
end
-- Init
function Level:Init(LevelName)
    if game.WorkSpace.Level1 then
        game.WorkSpace.Level1:Destroy()
    end
    if game.WorkSpace.Lobby then
        game.WorkSpace.Lobby:Destroy()
    end
    self.levelName = LevelName
    self.levelScript = MS.MainStorage.Level.LevelScript[LevelName .. "Script"]
    self.levelPrefab = MS.MainStorage.Level.LevelPrefab[LevelName]

    self:PreStartLevel()
end

function Level:InitLevelEnvironment()
    local environmentConfig = MS.DataConfig.Config_LevelEnvironment[self.levelName]
    MS.Environment.SkyLight.SkyLightType = environmentConfig.SkyLightType
    MS.Environment.SkyLight.AmbientSkyColor = environmentConfig.AmbientSkyColor
    MS.Environment.SkyLight.AmbientEquatorColor = environmentConfig.AmbientEquatorColor
    MS.Environment.SkyLight.AmbientGroundColor = environmentConfig.AmbientGroundColor
end

function Level:PreStartLevel()
    --self:InitLevelEnvironment()
    self.levelInstance = self.levelPrefab:Clone()
    self.levelInstance.Parent = MS.WorkSpace
    self.navigationMesh = _G.GameMode.navigationSystem:GenerateNavigationMesh(self:GetNavMeshInstance())
    --require(self.levelScript)
end

function Level:StartLevel()
    local weaponPlantInstances = self.levelState.weaponPlantInstances
    _G.PlayerController.eventObject:FireEvent("OnPossessWeaponPlants", weaponPlantInstances)
    _G.PlayerController.eventObject:FireEvent("OnLevelStart")

    -- Start Wave
    self:StartWave()
end

function Level:EndLevel(win)
    self.levelState.isLevelEnd = true

    self.levelState.zombieInstances = {}
    for positionIndex, weaponPlantInstance in pairs(self.levelState.weaponPlantInstances) do
        weaponPlantInstance:Destroy()
    end
    self.levelState.weaponPlantInstances = {}

    _G.PlayerController.eventObject:FireEvent("OnLevelEnd", win)
end

local function str_split(str, sep)
    local tb = {}
    local i = 1
    while true do
        local j = str:find(sep, i)
        if j then
            table.insert(tb, str:sub(i, j - 1))
            i = j + #sep
        else
            table.insert(tb, str:sub(i))
            break
        end
    end
    return tb
end

function Level:StartWave()
    local waveConfigs = self.levelPrefab.Waypoint.Spawns.Children
    local waves = {}

    for _, waveConfig in ipairs(waveConfigs) do
        local spawnConfigs = str_split(waveConfig.Value, "\r\n")

        -- 去掉首尾
        table.remove(spawnConfigs, 1)
        table.remove(spawnConfigs, #spawnConfigs)

        local spawns = {}
        for _, spawnConfig in ipairs(spawnConfigs) do
            local args = str_split(spawnConfig, ",")

            local spawn = {}
            spawn.waitTime = tonumber(args[1])
            spawn.point = args[2]
            spawn.zombieType = args[3]
            spawn.count = tonumber(args[4]) or 0
            spawn.tips = args[5]
            spawn.countDown = tonumber(args[6])
            if not MS.Config.GetCustomConfigNode(spawn.zombieType) then
                spawn.zombieType = nil
                spawn.count = 0
            end

            table.insert(spawns, spawn)
        end
        table.insert(waves, spawns)
    end

    self.levelState.totalWaveCount = #waves

    -- 计算zombieSum
    local levelZombieSum = 0
    for _, spawns in ipairs(waves) do
        for _, spawn in ipairs(spawns) do
            levelZombieSum = levelZombieSum + spawn.count
        end
    end

    for _, spawns in ipairs(waves) do
        _G.PlayerController.eventObject:FireEvent("OnWaveStart", self.levelState.currentWaveCount)

        local waveZombieSum = 0
        for _, spawn in ipairs(spawns) do
            waveZombieSum = waveZombieSum + spawn.count
        end
        print(waveZombieSum)
        for _, spawn in ipairs(spawns) do
            local zombieType = spawn.zombieType
            local waitTime = spawn.waitTime
            local count = spawn.count

            wait(waitTime)
            if spawn.countDown and spawn.countDown > 0 then
                _G.PlayerController.eventObject:FireEvent("OnCountDown", spawn.countDown)
            end
            for i = 1, count do
                self:SpawnZombie(zombieType, spawn.point)
            end
        end
        while ZManager.waveDeadZombieCount < waveZombieSum do
            wait(1)
        end
        print("wave end")
        self.levelState.currentWaveCount = self.levelState.currentWaveCount + 1
        _G.GameMode.levelManager.eventObject:FireEvent("OnWaveEnd")
        ZManager.waveDeadZombieCount = 0
    end
    while self.levelState.currentWaveCount < self.levelState.totalWaveCount and next(ZManager.zombies) ~= nil do
        wait(1)
    end
    _G.PlayerController.eventObject:FireEvent("OnLevelEnd", true)
    _G.GameMode.levelManager.eventObject:FireEvent("OnLevelEnd", true)
end

function Level:SpawnZombie(zombieType, startNode)
    --如果游戏结束，则跳出循环
    if self.levelState.isLevelEnd then
        return nil
    end

    local zombieInstance =
        ZManager:CreateZombie(zombieType, self.levelInstance, Vector3.New(0, 0, 0), Vector3.New(0, 0, 0), startNode)

    return zombieInstance
end

function Level:SpawnWeaponPlant(positionIndex, weaponPlantType)
    local SpawnWeaponPlantLocation =
        self.levelInstance:WaitForChild("WeaponPlantGroup"):WaitForChild("WeaponPlantPosition" .. positionIndex)
    local actorInstance =
        _G.GameMode.actorManager:SpawnActor(
        weaponPlantType,
        SpawnWeaponPlantLocation,
        Vector3.New(0, 40, 0),
        Vector3.New(0, 0, 0)
    )
    local weaponPlantInstance = MS.WeaponPlant.new(actorInstance)
    weaponPlantInstance:Init(positionIndex)
    self.levelState.weaponPlantInstances[positionIndex] = weaponPlantInstance
    return weaponPlantInstance
end

function Level:GetNavMeshInstance()
    return self.levelInstance:WaitForChild("Waypoint")
end

function Level:Destroy()
    self.levelInstance:Destroy()
end

return Level
