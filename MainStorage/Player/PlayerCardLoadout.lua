local PlayerCardLoadout = MS.Class.new("PlayerCardLoadout")

-- SceneInstances Infos stored in ClientSide
function PlayerCardLoadout:ctor()
    self.playerCards = {}
end

function PlayerCardLoadout:Init(playerCards)
    self.playerCards = playerCards
end

function PlayerCardLoadout:GetPlayerCard(cardID)
    return self.playerCards[cardID]
end

function PlayerCardLoadout:GetPlayerCards()
    return self.playerCards
end

function PlayerCardLoadout:AddPlayerCard(playerCard)
    table.insert(self.playerCards, playerCard)
end

function PlayerCardLoadout:RemovePlayerCard(cardID)
    self.playerCards[cardID] = nil
end

return PlayerCardLoadout
