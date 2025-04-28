-- SceneInstances Infos stored in ServerSide
local GameMode = MS.Class.new("GameMode")

function GameMode:ctor()
    self.levelManager = MS.LevelManager.new()
    self.actorManager = MS.ActorManager.new()
    self.navigationSystem = MS.NavigationSystem.new()
end

function GameMode:Init()
    self.levelManager:Init()
    self.actorManager:Init()
    self.navigationSystem:Init()
    self:InitCollisionGroup()
end

-- Common
function GameMode:InitCollisionGroup()
    -- Set CollisionGroup
    -- 6 for drop,
    -- 5 for scene,
    -- 4 for bullet,
    -- 3 for zombie,
    -- 2 for plant,
    -- 1 for floor

    -- Zombie
    MS.PhysXService:SetCollideInfo(3, 3, false)
    MS.PhysXService:SetCollideInfo(3, 1, false)
    -- Plant
    MS.PhysXService:SetCollideInfo(2, 4, false)
    MS.PhysXService:SetCollideInfo(2, 5, false)
end

return GameMode
