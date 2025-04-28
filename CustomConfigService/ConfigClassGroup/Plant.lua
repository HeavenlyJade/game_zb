local actorAttributes = {
    {
        AttrName = "name",
        AttrType = "SubAttrs",
        DefaultValue = ""
    },
    {
        AttrName = "damage",
        AttrType = "double",
        DefaultValue = 0
    },
    {
        AttrName = "health",
        AttrType = "double",
        DefaultValue = 100
    },
    {
        AttrName = "lifetime",
        AttrType = "double",
        DefaultValue = 0
    },
	{
        AttrName = "spawnObjectName",
        AttrType = "string",
        DefaultValue = ""
    },
}

local configDesc = {
    -- Attribute
    {
        AttrName = "actorType",
        AttrType = "string",
        DefaultValue = ""
    },
    {
        AttrName = "Attributes",
        AttrType = "table",
        SubAttrs = actorAttributes,
        SubAttrsClass = "actorAttributes"
    }
}

return configDesc
