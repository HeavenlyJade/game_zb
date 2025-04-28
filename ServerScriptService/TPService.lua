local CloudService = game:GetService("CloudService")

local M = {}

function M.TPPlayerToMap(uid, mapId)
    local customInfo = ""
    local reportInfo = ""
    local showConfirmationDialog = false
    local result = CloudService:TeleportToMap(mapId, uid, customInfo, reportInfo, showConfirmationDialog)
    print("uid", uid, " go to map ", mapId, " result is ", tostring(result))
end

function M.StartService()
    Bridge.RegisterClientMessageCallback(Protocol.ClientMsgID.TELEPORT_REQUEST, function(userId, messageId, messageBody)
        print("Recv Tp Msg", userId)
        M.TPPlayerToMap(userId, messageBody.mapId)
    end)
end

return M