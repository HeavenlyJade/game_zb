local WeaponPlantCard = MS.Class.new("WeaponPlantCard")

function WeaponPlantCard:ctor()
    self.cardID = 0
    self.weaponPlantPrefab = ""
    self.starRank = 1
    self.level = 1
    self.experience = 0
    self.icon = ""
    self.attributes = {
        maxHealth = 0,
        damage = 0,
        attackSpeed = 0
    }
end

function WeaponPlantCard:Init()
    local cardConfig = MS.DataConfig.Config_WeaponPlantCard[self.weaponPlantPrefab]
    self.icon = cardConfig.icon
    self.starRank = cardConfig.starRank

    local plantConfig = require(MS.Config.GetCustomConfigNode(self.weaponPlantPrefab).Data)
    local weaponConfig = MS.DataConfig.Config_WeaponPlant[self.weaponPlantPrefab]
    self.attributes = {
        maxHealth = plantConfig.Attributes.health,
        damage = plantConfig.Attributes.damage,
        attackSpeed = weaponConfig.Attributes.fire_rate
    }

    self:CalculateAttributes()
end

function WeaponPlantCard:CalculateAttributes()
    -- Test
    self.attributes.maxHealth = (self.attributes.maxHealth + self.level) * self.starRank
    self.attributes.damage = (self.attributes.damage + self.level) * self.starRank
    self.attributes.attackSpeed = (self.attributes.attackSpeed + self.level) * self.starRank
end

return WeaponPlantCard
