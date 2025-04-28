local CloudManager = MS.Class.new("CloudManager")

function CloudManager:ctor()
    self.eventObject = MS.EventObject.new()
    self.eventNames = {
        "SetPlayerCloudCache",
        "GetPlayerCloudCache",
        "WriteCacheToCloud",
        "ReadCacheFromCloud"
    }
    self.playersCloudCache = {}
end

function CloudManager:Init()
    self:RegisterServerEvents()
end

function CloudManager:RegisterServerEvents()
    for _, eventName in pairs(self.eventNames) do
        self.eventObject:On(
            eventName,
            function(...)
                self:Update(eventName, ...)
            end
        )
    end
end

function CloudManager:Update(eventName, ...)
    local uid = select(1, ...)
    local playerDataType = select(2, ...)
    if eventName == "SetPlayerCloudCache" then
        return self:SetPlayerCloudCache(uid, playerDataType, ...)
    elseif eventName == "GetPlayerCloudCache" then
        return self:GetPlayerCloudCache(uid, playerDataType)
    elseif eventName == "WriteCacheToCloud" then
        return self:WriteCacheToCloud(uid)
    elseif eventName == "ReadCacheFromCloud" then
        return self:ReadCacheFromCloud(uid)
    end
end

function CloudManager:InitPlayerCloudCache(uid)
    if self.playersCloudCache[uid] == nil then
        self.playersCloudCache[uid] = {}
    end
end

function CloudManager:GetPlayerCloudCache(uid, playerDataType)
    if self.playersCloudCache[uid] == nil or self.playersCloudCache[uid][playerDataType] == nil then
        return nil
    end
    local cacheData = {}
    if playerDataType == "PlayerCard" then
        cacheData = self.playersCloudCache[uid][playerDataType]
    end
    return cacheData
end

function CloudManager:SetPlayerCloudCache(uid, playerDataType, cardTable)
    if self.playersCloudCache[uid] == nil then
        self.playersCloudCache[uid] = {}
    end

    if self.playersCloudCache[uid][playerDataType] == nil then
        self.playersCloudCache[uid][playerDataType] = {}
    end

    if playerDataType == "PlayerCard" then
        self.playersCloudCache[uid][playerDataType] = cardTable
    end
end

function CloudManager:ReadCacheFromCloud(uid)
    local uidString = tostring(uid)
    MS.CloudService:GetTableAsync(
        uidString,
        function(success, data)
            print(success, data)
            return success
        end
    )
end

function CloudManager:WriteCacheToCloud(uid)
    if self.playersCloudCache[uid] == nil then
        return false
    end
    local uidString = tostring(uid)
    MS.CloudService:SetTableAsync(
        uidString,
        self.playersCloudCache[uidString],
        function(success, data)
            print(success, data)
            return success
        end
    )
end

return CloudManager
