local actorAttributes = {
    {
        AttrName = "damage",
        AttrType = "double",
        DefaultValue = 0
    },
    {
        AttrName = "lifetime",
        AttrType = "double",
        DefaultValue = 0
    },
	{
		AttrName = "hitEffect",
        AttrType = "string",
        DefaultValue = ""
	},
		{
		AttrName = "hitSound",
        AttrType = "string",
        DefaultValue = ""
	},
    {
        AttrName = "penetrateMax",
        AttrType = "double",
        DefaultValue = 1
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
