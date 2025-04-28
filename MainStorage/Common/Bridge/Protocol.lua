-- 客户端-服务器协议 (Callback)
local Protocol = {
    -- 客户端协议  区间[1000,2000)
    ClientMsgID = {
        TEST = 1001, --  测试用
        GETPLAYERCARDS = 1002, --  获取玩家卡牌
        SETPLAYERCARD = 1003, --  设置玩家卡牌,
		TELEPORT_REQUEST = 1901, --  传送请求
    },
    -- 服务器协议  区间[2000,-]
    ServerMsgID = {
        TEST = 2001, --  测试用
        GETPLAYERCARDSCOMPLETE = 2002, --  获取玩家卡牌完成
        SETPLAYERCARDCOMPLETE = 2003, --  设置玩家卡牌完成
		TELEPORT_RESPONSE = 2901, --  传送响应
    }
}

return Protocol
