local Class = {}
Class.new = function(className, parent_cls)
    local cls = {}

    cls.ctor = false

    if parent_cls ~= nil then
        cls.super = parent_cls
        setmetatable(cls, { __index = parent_cls })
    end

    cls.__cname = className
    cls.__index = cls
    --实例化
    cls.new = function(...)
        local obj
        -- 递归调用构造函数
        do
            local create_func 
            create_func = function(c, ...)
                if c.super then
                    create_func(c.super, ...)
                end

                if not obj then
                    obj = {}
                    setmetatable(obj, cls)
                    obj.class = cls
                end

                if c.ctor then
                    c.ctor(obj, ...)
                end
            end

            create_func(cls, ...)
        end
        if obj and obj._on_new then
            obj:_on_new()
        end
        return obj
    end
    --销毁
    cls.destroy = function(obj)
        if obj and obj._on_delete then
            obj:_on_delete()
        end
        -- 递归调用析构函数
        local destroy_func
        destroy_func = function(c)
            local dtor = rawget(c, 'dtor')
            if dtor then
                dtor(obj)
            end

            if c.super then
                destroy_func(c.super)
            end
        end

        destroy_func(obj.class)
        obj.__delete__ = true
    end
	return cls
end

local function IsAHelper(obj, cls, cls_name)
    if cls.__cname == cls_name then
        return true
    elseif cls.super then
        return IsAHelper(obj, cls.super, cls_name)
    else
        return false
    end
end

Class.IsA = function(obj, cls_name)
    return IsAHelper(obj, obj.class, cls_name)
end

return Class