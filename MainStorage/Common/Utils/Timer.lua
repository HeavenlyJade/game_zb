--Timer.lua
local Timer = {}

function Timer.CreateTimer(delay, interval, loop, callbackFunc)
    local timer = SandboxNode.New("Timer")

    timer.Delay = delay
    timer.Interval = interval
    timer.Loop = loop
    timer.Callback = function()
        callbackFunc()
        -- if timer.Loop == false then
        --     timer:Destroy()
        -- end
    end
    return timer
end

return Timer
