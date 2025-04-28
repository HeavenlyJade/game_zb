-- Bridge.lua
local Bridge = {}
Bridge.GeneralRemoteEvent = script.GeneralRemoteEvent
Bridge.GeneralRemoteFunction = script.GeneralRemoteFunction

Bridge.ClientMessageCallbackPools = {}
Bridge.ServerMessageCallbackPools = {}

local callback = {}
callback.new = function(callbackFunction)
    return {
        callback = callbackFunction,
        valid = true
    }
end

Bridge.RegisterClientMessageCallback = function(id, fun)
    if MS.RunService:IsServer() then
        local pool = Bridge.ClientMessageCallbackPools[id]
        if nil == pool then
            pool = {}
            Bridge.ClientMessageCallbackPools[id] = pool
        end

        if pool[fun] ~= nil and true == pool[fun].valid then
            print("message callback already exists")
        else
            pool[fun] = callback.new(fun)
        end
    else
        print("RegisterClientMessageCallback:this is server script api")
    end
end

Bridge.CancelClientMessageCallback = function(id, fun)
    if MS.RunService:IsServer() then
        local pool = Bridge.ClientMessageCallbackPools[id]
        if nil ~= pool and nil ~= pool[fun] then
            pool[fun].valid = false
        else
            print("Client Message Callback not exists, ClientMsgID : " .. id)
        end
    else
        print("CancelClientMessageCallback:this is server script api")
    end
end

Bridge.RegisterServerMessageCallback = function(id, fun)
    if MS.RunService:IsClient() then
        local pool = Bridge.ServerMessageCallbackPools[id]
        if nil == pool then
            pool = {}
            Bridge.ServerMessageCallbackPools[id] = pool
        end

        if pool[fun] ~= nil then
            print("message callback already exists")
        else
            pool[fun] = callback.new(fun)
        end
    else
        print("RegisterServerMessageCallback:this is client script api")
    end
end

Bridge.CancelServerMessageCallback = function(id, fun)
    if MS.RunService:IsClient() then
        local pool = Bridge.ServerMessageCallbackPools[id]
        if nil ~= pool and nil ~= pool[fun] then
            pool[fun].valid = false
        else
            print("Server Message Callback not exists, ServerMsgID : " .. id)
        end
    else
        print("CancelServerMessageCallback:this is server script api")
    end
end

Bridge.BroadcastMessage = function(msgid, body)
    if MS.RunService:IsServer() then
        if msgid == nil then
            print("nil msgid")
            return
        end

        Bridge.GeneralRemoteEvent:FireAllClients(msgid, body)
    else
        print("BroadcastMessage:this is server script api")
    end
end

Bridge.SendMessageToClient = function(playerId, msgid, body, GetReturnValue)
    if MS.RunService:IsServer() then
        if msgid == nil then
            print("nil msgid")
            return
        end
        if GetReturnValue == true then
            return Bridge.GeneralRemoteFunction:InvokeClient(playerId, msgid, body)
        else
            Bridge.GeneralRemoteEvent:FireClient(playerId, msgid, body)
        end
    else
        print("SendMessageToClient:this is server script api")
    end
end

Bridge.SendMessageToServer = function(msgid, body, GetReturnValue)
    if MS.RunService:IsClient() then
        if msgid == nil then
            print("nil msgid")
            return
        end
        if msgid==MS.Protocol.ClientMsgID.TELEPORT_REQUEST then
            game.CoreUI:ExitGame()
        elseif GetReturnValue == true then
            return Bridge.GeneralRemoteFunction:InvokeServer(msgid, body)
        else
            Bridge.GeneralRemoteEvent:FireServer(msgid, body)
        end
    else
        print("SendMessageToServer:this is client script api")
    end
end

local RunService = game:GetService("RunService")
if RunService:IsClient() then
    Bridge.GeneralRemoteEvent.OnClientNotify:Connect(
        function(msgid, bin)
            -- print('temp',"OnClientNotify msgid : ", msgid, " , bin : ", bin or "")

            local pool = Bridge.ServerMessageCallbackPools[msgid]
            if pool then
                for _, value in pairs(pool) do
                    if value.valid then
                        value.callback(msgid, bin)
                    end
                end
            end
        end
    )

    Bridge.GeneralRemoteFunction.OnClientInvoke = (function(msgid, bin)
        local pool = Bridge.ServerMessageCallbackPools[msgid]
        if pool then
            for _, value in pairs(pool) do
                if value.valid then
                    return value.callback(msgid, bin)
                end
            end
        end
    end)
end

if RunService:IsServer() then
    Bridge.GeneralRemoteEvent.OnServerNotify:Connect(
        function(playerId, msgid, bin)
            -- print('temp',"OnServerNotify msgid : ", msgid, " , bin : ", bin or "")
            local pool = Bridge.ClientMessageCallbackPools[msgid]
            if pool then
                for _, value in pairs(pool) do
                    if value.valid then
                        value.callback(playerId, msgid, bin)
                    end
                end
            end
        end
    )

    Bridge.GeneralRemoteFunction.OnServerInvoke = (function(playerId, msgid, bin)
        -- print('temp',"OnServerNotify msgid : ", msgid, " , bin : ", bin or "")
        local pool = Bridge.ClientMessageCallbackPools[msgid]
        if pool then
            for _, value in pairs(pool) do
                if value.valid then
                    return value.callback(playerId, msgid, bin)
                end
            end
        end
    end)
end

return Bridge
