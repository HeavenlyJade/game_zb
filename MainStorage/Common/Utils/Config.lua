local Config = {}

function Config.GetCustomConfigNode(ConfigNodeID)
    if MS.CustomConfigService then
        local customNode = MS.CustomConfigService.ConfigGroup[ConfigNodeID]
        if customNode then
            return customNode
        else
            return nil
        end
    end
end

function Config.GetCustomGroupConfigNode(configName)
    if MS.CustomConfigService then
        local configNode = MS.CustomConfigService.ConfigClassGroup[configName]
        if configNode then
            return require(configNode)
        end
    end
end


return Config
