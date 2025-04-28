local EventObject = MS.Class.new("EventObject")
--自动事件id
EventObject.autoEventId = 0

function EventObject:ctor()
    --事件列表
    self.events = {}
    --是否屏蔽事件
    self.blockEvent = false

    --正在触发事件中
    self.triggeringEvent = false
    self.addListenerTemp = {}
    self.removeListenerTemp = {}
end

function EventObject:GetAutoEventId()
    self.autoEventId = self.autoEventId + 1
    return self.autoEventId
end

function EventObject:Init()
end

--屏蔽事件
function EventObject:BlockEvent(block)
    self.blockEvent = block
end

--注册事件
function EventObject:AddListener(eventName, callback)
    if self.triggeringEvent then
        if not self.addListenerTemp then
            self.addListenerTemp = {}
        end
        table.insert(self.addListenerTemp, {callback = callback, eventName = eventName})
        return
    end
    self:RemoveListener(eventName, callback)
    if self.events == nil then
        self.events = {}
    end
    if self.events[eventName] == nil then
        self.events[eventName] = {}
    end
    local eventId = self:GetAutoEventId()
    table.insert(self.events[eventName], {callback = callback, eventId = eventId})
    return eventId
end
--做一个简易封装
function EventObject:On(eventName, callback)
    return self:AddListener(eventName, callback)
end

--移除事件
function EventObject:RemoveListener(eventName, callback)
    if self.triggeringEvent then
        if not self.removeListenerTemp then
            self.removeListenerTemp = {}
        end
        table.insert(self.removeListenerTemp, {callback = callback, eventName = eventName})
        return
    end
    if self.events == nil then
        self.events = {}
        return
    end
    if self.events[eventName] == nil then
        return
    end
    for k, v in pairs(self.events[eventName]) do
        if v.callback == callback then
            table.remove(self.events[eventName], k)
            return
        end
    end
end

function EventObject:RemoveByEventId(eventId)
    if self.triggeringEvent then
        if not self.removeListenerTemp then
            self.removeListenerTemp = {}
        end
        table.insert(self.removeListenerTemp, {eventId = eventId})
        return
    end
    for k, v in pairs(self.events) do
        for kk, vv in pairs(v) do
            if vv.eventId == eventId then
                table.remove(self.events[k], kk)
                return
            end
        end
    end
end
--简易封装
function EventObject:Off(eventName, callback)
    self:RemoveListener(eventName, callback)
end

function EventObject:OffByEventId(eventId)
    self:RemoveByEventId(eventId)
end

--触发事件
function EventObject:FireEvent(eventName, ...)
    if self.blockEvent then
        return
    end
    if self.events == nil then
        self.events = {}
        return
    end
    if self.events[eventName] == nil then
        return
    end
    self.triggeringEvent = true
    for k, v in pairs(self.events[eventName]) do
        local args = {...}
        PCall(
            function()
                v.callback(unpack(args))
            end
        )
    end
    self.triggeringEvent = false
    if self.addListenerTemp then
        for _, v in ipairs(self.addListenerTemp) do
            self:AddListener(v.eventName, v.callback)
        end
        self.addListenerTemp = {}
    end

    if self.removeListenerTemp then
        for _, v in ipairs(self.removeListenerTemp) do
            if v.eventId then
                self:RemoveByEventId(v.eventId)
            else
                self:RemoveListener(v.eventName, v.callback)
            end
        end
        self.removeListenerTemp = {}
    end
end

return EventObject
