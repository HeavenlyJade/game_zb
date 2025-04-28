local RunService = game:GetService("RunService")
local M = {}

M.timeId = 0
function M.GenTimeId()
    M.timeId = M.timeId + 1
    return M.timeId
end

M.timeIdCallMap = {}
M.delayActionIds = {}
M.isScheduleing = false

function M.Init()
    if RunService:IsServer() then
        M.steppedIns = RunService.Stepped:Connect(M.PerformCall)
    else
        M.steppedIns = RunService.RenderStepped:Connect(M.PerformCall)
    end
end

function M.DelayCall(func, delayMs)
    return M.RepeatCall(func, 1, delayMs)
end

function M.RepeatCall(func, callCount, startDelayMs, loopDelayMs)
    local curMs = RunService:CurrentMilliSecondTimeStamp()
    if callCount == nil then
        callCount = 0xFFFFFFFF
    end
    if startDelayMs == nil then
        startDelayMs = 0
    end
    if loopDelayMs == nil then
        loopDelayMs = startDelayMs
    end
    startDelayMs = startDelayMs + curMs
    local timeId = M.GenTimeId()
    print("entry reg", timeId, callCount, startDelayMs, loopDelayMs)
    if M.isScheduleing then
        M.delayActionIds[#M.delayActionIds+1] = function()
            M.timeIdCallMap[timeId] = {func, callCount, startDelayMs, loopDelayMs}
        end
    else
        M.timeIdCallMap[timeId] = {func, callCount, startDelayMs, loopDelayMs, curMs}
    end
    return timeId
end

function M.PerformCall()
    M.isScheduleing = true
    local curMs = RunService:CurrentMilliSecondTimeStamp()
    for timeId, items in pairs(M.timeIdCallMap) do
        local startDelayMs = items[3]
        if startDelayMs >= 0 then
            -- first trigger
            -- print("entry" ,timeId, curMs, startDelayMs)
            if curMs >= startDelayMs then
                items[1]()
                items[3] = -1
                items[5] = curMs
                items[2] = items[2] - 1
            end
        else
            local lastTriggerTime = items[5]
            local loopDelayMs = items[4]
            local gap = curMs - lastTriggerTime
            if gap >= loopDelayMs then
                items[1]()
                items[5] = curMs 
                items[2] = items[2] - 1
            end
        end
        if items[2] <= 0 then
            M.Cancel(timeId)
        end
    end

    M.isScheduleing = false
    if #M.timeIdCallMap > 0 then
        for i,v in ipairs(M.delayActionIds) do
            v()
        end
        M.delayActionIds = {}
    end
end

function M.Cancel(timeId)
    if M.isScheduleing then
        M.delayActionIds[#M.delayActionIds+1] = function()
            print("entry cancel", timeId)
            M.timeIdCallMap[timeId] = nil
        end
    else
        M.timeIdCallMap[timeId] = nil
        print("entry cancel", timeId)
    end
end

return M