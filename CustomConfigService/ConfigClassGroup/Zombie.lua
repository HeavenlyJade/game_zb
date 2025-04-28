local actorAttributes = {
    {
        AttrName = "damage",
        AttrType = "double",
        DefaultValue = 100
    },
    {
        AttrName = "health",
        AttrType = "double",
        DefaultValue = 10
    },
	{
		AttrName = "armor",
        AttrType = "double",
        DefaultValue = 0
	},
    {
        AttrName = "moveSpeed",
        AttrType = "double",
        DefaultValue = 500
    },
    {
        AttrName = "attackSpeed",
        AttrType = "double",
        DefaultValue = 0.2
    },
    {
        AttrName = "lifetime",
        AttrType = "double",
        DefaultValue = 0
    }
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
