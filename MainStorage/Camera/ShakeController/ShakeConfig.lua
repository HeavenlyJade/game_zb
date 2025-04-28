--摄像头震动配置
local CameraShakeConfig = {
    ["PeaShooter"] = {
        -- 使用线性缓动
        easing = "Linear",
        -- 缓动参数
        easingStart = 1.0,
        easingEnd = 0.0,
        -- 晃动持续时间(秒)
        duration = 0.05,
        -- 晃动频率
        frequency = 0.05,
        -- 晃动强度
        strength = 1.0,
        -- 旋转参数(度)
        rotX = 20, -- 上下晃动
        rotY = 20, -- 左右晃动
        rotZ = 0.0, -- 画面倾斜
        -- 位移参数
        posX = 0.0, -- 左右位移
        posY = 0.0, -- 上下位移
        posZ = 0.0 -- 前后位移
    },
    ["MGPeaShooter"] = {
        -- 使用线性缓动
        easing = "Linear",
        -- 缓动参数
        easingStart = 1.0,
        easingEnd = 0.0,
        -- 晃动持续时间(秒)
        duration = 0.08,
        -- 晃动频率
        frequency = 0.08,
        -- 晃动强度
        strength = 1.0,
        -- 旋转参数(度)
        rotX = 15, -- 上下晃动
        rotY = 25, -- 左右晃动
        rotZ = 0.0, -- 画面倾斜
        -- 位移参数
        posX = 15.0, -- 左右位移
        posY = 5.0, -- 上下位移
        posZ = 0.0 -- 前后位移
    },
    ["SnowPeaShooter"] = {
        -- 使用线性缓动
        easing = "Linear",
        -- 缓动参数
        easingStart = 1.0,
        easingEnd = 0.0,
        -- 晃动持续时间(秒)
        duration = 0.15,
        -- 晃动频率
        frequency = 0.05,
        -- 晃动强度
        strength = 1.0,
        -- 旋转参数(度)
        rotX = 0.8, -- 上下晃动
        rotY = 0.2, -- 左右晃动
        rotZ = 10.0, -- 画面倾斜
        -- 位移参数
        posX = 2.0, -- 左右位移
        posY = 1.0, -- 上下位移
        posZ = 0.5 -- 前后位移
    },
    ["FumeShroom"] = {
        -- 使用线性缓动
        easing = "Linear",
        -- 缓动参数
        easingStart = 1.0,
        easingEnd = 0.0,
        -- 晃动持续时间(秒)
        duration = 0.15,
        -- 晃动频率
        frequency = 0.05,
        -- 晃动强度
        strength = 1.0,
        -- 旋转参数(度)
        rotX = 0.8, -- 上下晃动
        rotY = 0.2, -- 左右晃动
        rotZ = 10.0, -- 画面倾斜
        -- 位移参数
        posX = 2.0, -- 左右位移
        posY = 1.0, -- 上下位移
        posZ = 0.5 -- 前后位移
    },
    ["SplitPeaShooter"] = {
        -- 使用线性缓动
        easing = "Linear",
        -- 缓动参数
        easingStart = 1.0,
        easingEnd = 0.0,
        -- 晃动持续时间(秒)
        duration = 0.15,
        -- 晃动频率
        frequency = 0.05,
        -- 晃动强度
        strength = 1.0,
        -- 旋转参数(度)
        rotX = 0.8, -- 上下晃动
        rotY = 0.2, -- 左右晃动
        rotZ = 10.0, -- 画面倾斜
        -- 位移参数
        posX = 2.0, -- 左右位移
        posY = 1.0, -- 上下位移
        posZ = 0.5 -- 前后位移
    },
    ["CherryBomb"] = {
        -- 使用线性缓动
        easing = "Linear",
        -- 缓动参数
        easingStart = 1.0,
        easingEnd = 0.0,
        -- 晃动持续时间(秒)
        duration = 0.05,
        -- 晃动频率
        frequency = 0.02,
        -- 晃动强度
        strength = 2.0,
        -- 旋转参数(度)
        rotX = 20, -- 上下晃动
        rotY = 30, -- 左右晃动
        rotZ = 0.0, -- 画面倾斜
        -- 位移参数
        posX = 0.0, -- 左右位移
        posY = 0.0, -- 上下位移
        posZ = 0.0, -- 前后位移

        times = 6,
    }
}

return CameraShakeConfig
