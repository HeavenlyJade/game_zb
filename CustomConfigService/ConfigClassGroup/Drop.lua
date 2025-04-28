local actorAttributes = {
    {
        AttrName = "name",
        AttrType = "string",
        DefaultValue = ""
    },
    {
        AttrName = "magnitude",
        AttrType = "double",
        DefaultValue = 0
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
