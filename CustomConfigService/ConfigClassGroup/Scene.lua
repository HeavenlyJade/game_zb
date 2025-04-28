local actorAttributes = {
    {
        AttrName = "LawnmowerSpeed",
        AttrType = "double",
        DefaultValue = 1000
    },
    {
        AttrName = "LawnmowerLifetime",
        AttrType = "double",
        DefaultValue = 10
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
