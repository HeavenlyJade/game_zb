local PlayerState = MS.Class.new("PlayerState")

function PlayerState:ctor()
    -- player state
    self.zombieKillCount = 0
    self.weaponPlantCards = {}
end

function PlayerState:Init(weaponPlantCards)
    self.weaponPlantCards = weaponPlantCards
end

function PlayerState:SetWeaponPlantCards(weaponPlantCardIDs)
    for _, weaponPlantCardID in pairs(weaponPlantCardIDs) do
        -- TODO: Fetch Data from KV
        -- local weaponPlantCard = MS.DataConfig.Config_WeaponPlantCard[weaponPlantCardID]
        -- table.insert(self.weaponPlantCards, weaponPlantCard)
    end
end

function PlayerState:AddWeaponPlantCard(weaponPlantCard, positionIndex)
    self.weaponPlantCards[positionIndex] = weaponPlantCard
end

return PlayerState
