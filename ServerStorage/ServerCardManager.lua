local ServerCardManager = MS.Class.new("ServerCardManager")

function ServerCardManager:ctor()
end

function ServerCardManager:Init()
    self:RegisterClientCallback()
    self:RegisterEvent()
end

function ServerCardManager:RegisterClientCallback()
    MS.Bridge.RegisterClientMessageCallback(
        MS.Protocol.ClientMsgID.GETPLAYERCARDS,
        function(userId, messageId, messageBody)
            local playerCards = self:GetPlayerCards(userId)
            return playerCards
        end
    )
    MS.Bridge.RegisterClientMessageCallback(
        MS.Protocol.ClientMsgID.SETPLAYERCARD,
        function(userId, messageId, messageBody)
            self:SetPlayerCard(userId, messageBody.cardID, messageBody.card)
        end
    )
end

function ServerCardManager:RegisterEvent()
    MS.Players.PlayerAdded:Connect(
        function(player)
            -- TEST
            local testCards = {
                [1] = {
                    cardID = 1,
                    weaponPlantPrefab = "PeaShooter",
                    starRank = 1,
                    level = 1,
                    icon = "sandboxId://PVZ_UI/Common/Icon/Plants/Plants001.png"
                },
                [2] = {
                    cardID = 2,
                    weaponPlantPrefab = "MGPeaShooter",
                    starRank = 1,
                    level = 1,
                    icon = "sandboxId://PVZ_UI/Common/Icon/Plants/Plants005.png"
                },
                [3] = {
                    cardID = 3,
                    weaponPlantPrefab = "SnowPeaShooter",
                    starRank = 1,
                    level = 1,
                    icon = "sandboxId://PVZ_UI/Common/Icon/Plants/Plants004.png"
                },
                [4] = {
                    cardID = 4,
                    weaponPlantPrefab = "SplitPeaShooter",
                    starRank = 1,
                    level = 1,
                    icon = "sandboxId://PVZ_UI/Common/Icon/Plants/Plants006.png"
                },
                [5] = {
                    cardID = 5,
                    weaponPlantPrefab = "FumeShroom",
                    starRank = 1,
                    level = 1,
                    icon = "sandboxId://PVZ_UI/Common/Icon/Plants/Plants007.png"
                }
            }
            _G.CloudManager:SetPlayerCloudCache(player.UserId, "PlayerCard", testCards)
            MS.Bridge.SendMessageToClient(
                player.UserId,
                MS.Protocol.ServerMsgID.GETPLAYERCARDSCOMPLETE,
                {
                    playerCards = testCards
                },
                false
            )
        end
    )
end

function ServerCardManager:GetPlayerCards(uid)
    local uidString = tostring(uid)
    return _G.CloudManager:GetPlayerCloudCache(uidString, "PlayerCard")
end

function ServerCardManager:SetPlayerCard(uid, cardID, card)
    local uidString = tostring(uid)
    local modifyCardTable = _G.CloudManager:GetPlayerCloudCache(uidString, "PlayerCard")
    if modifyCardTable == nil then
        modifyCardTable = {}
    end
    modifyCardTable[cardID] = card

    _G.CloudManager:SetPlayerCloudCache(uidString, "PlayerCard", modifyCardTable)
end

return ServerCardManager
