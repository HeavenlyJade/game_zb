local Workspace = game:GetService("Workspace")
local MaterialService = game:GetService("MaterialService")
local rs = game:GetService("RunService")

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function Vec4Lerp(a, b ,t)
    return Vector4.New(lerp(a.X, b.X, t), lerp(a.Y, b.Y, t), lerp(a.Z, b.Z, t), lerp(a.W, b.W, t))
end

local WeatherPreset = {}

function WeatherPreset.New()
    local ret = {}
    ret.name = nil
    --天气类型
    ret.weatherType = nil
    --天气强度
    ret.weatherIntensity = nil
    --天气持续时间
    ret.weatherDuration = nil

    ret.lightDirection = nil
    ret.lightIntensity = nil
    ret.lightColor = nil

    ret.fogDensity = nil
    ret.fogColor = nil
    ret.fogStart = nil
    ret.fogEnd = nil

    ret.effect = nil

    ret.snowAmount = nil
    ret.windStrength = nil
    ret.wetness = nil

    ret.skybox = nil
    ret.skyboxAlpha = nil
    setmetatable(ret, {__index = WeatherPreset})
    return ret
end

local function ToString(value)
    local ret = ""
    for k,v in pairs(value) do
        ret = ret .. "key is " .. tostring(k) .. " value is " .. tostring(v)
    end
    return ret
end


function WeatherPreset:Lerp(target, time)
    local data = {}

    local selfLightDirection = Quaternion.FromEuler(self.lightDirection.X, self.lightDirection.Y, self.lightDirection.Z)
    local targetLightDirection = Quaternion.FromEuler(target.lightDirection.X, target.lightDirection.Y, target.lightDirection.Z)
    local dirDelta = selfLightDirection:Lerp(targetLightDirection, time)

    data.lightDirection = Vector3.FromQuaternion(dirDelta)
    data.lightIntensity = lerp(self.lightIntensity, target.lightIntensity, time)
    data.lightColor = Vec4Lerp(self.lightColor, target.lightColor, time)

    data.fogDensity = lerp(self.fogDensity, target.fogDensity, time)
    data.fogColor = Vec4Lerp(self.fogColor, target.fogColor, time)
    data.fogStart = lerp(self.fogStart, target.fogStart, time)
    data.fogEnd = lerp(self.fogEnd, target.fogEnd, time)


    data.snowAmount = lerp(self.snowAmount, target.snowAmount, time)
    data.windStrength = lerp(self.windStrength, target.windStrength, time)
    data.wetness = lerp(self.wetness, target.wetness, time)

    data.skyboxAlpha = time

    return data
end


--导出参数数据
function WeatherPreset:GetWeatherData()
    local data = {}

    data.lightDirection = Vector3.New(self.lightDirection.X, self.lightDirection.Y, self.lightDirection.Z)
    data.lightIntensity = self.lightIntensity
    data.lightColor = Vector4.New(self.lightColor.X, self.lightColor.Y, self.lightColor.Z, self.lightColor.W)

    data.fogDensity = self.fogDensity
    data.fogColor = Vector4.New(self.fogColor.X, self.fogColor.Y, self.fogColor.Z, self.fogColor.W)
    data.fogStart = self.fogStart
    data.fogEnd = self.fogEnd

    data.snowAmount = self.snowAmount
    data.windStrength = self.windStrength
    data.wetness = self.wetness

    data.skyboxAlpha = 1
    
    return data
end

function WeatherPreset:SetWeatherData(data)
    self.lightDirection = Vector3.New(data.lightDirection.X, data.lightDirection.Y, data.lightDirection.Z)
    self.lightIntensity = data.lightIntensity
    self.lightColor = Vector4.New(data.lightColor.X, data.lightColor.Y, data.lightColor.Z, data.lightColor.W)

    self.fogDensity = data.fogDensity
    self.fogColor = Vector4.New(data.fogColor.X, data.fogColor.Y, data.fogColor.Z, data.fogColor.W)
    self.fogStart = data.fogStart
    self.fogEnd = data.fogEnd

    self.snowAmount = data.snowAmount
    self.windStrength = data.windStrength
    self.wetness = data.wetness

    self.skyboxAlpha = data.skyboxAlpha
end

function WeatherPreset:LoadConfig(config)
    self.weatherType = config.weatherType
    self.weatherIntensity = config.weatherIntensity
    self.weatherDuration = config.weatherDuration

    self.lightDirection = Vector3.New(config.lightDirection[1], config.lightDirection[2], config.lightDirection[3])
    self.lightIntensity = config.lightIntensity
    self.lightColor = Vector4.New(config.lightColor[1] / 255, config.lightColor[2] / 255, config.lightColor[3] / 255, config.lightColor[4] / 255)

    self.fogDensity = config.fogDensity
    self.fogColor = Vector4.New(config.fogColor[1] / 255, config.fogColor[2] / 255, config.fogColor[3] / 255, config.fogColor[4] / 255)
    self.fogStart = config.fogStart
    self.fogEnd = config.fogEnd

    self.effect = config.effect

    self.snowAmount = config.snowAmount
    self.windStrength = config.windStrength
    self.wetness = config.wetness

    self.skybox = config.skybox
    self.skyboxAlpha = config.skyboxAlpha
end

function WeatherPreset:LoadDataFromTid(tid)
    self.tid = tid
    self.name = tid
    self:LoadConfig(require(script.WeatherConfig[tostring(tid)]))
end


local M = {}
M.renderSteppedIns = nil

function M.Init()
    M.weatherList = {}

    M.currentWeather = nil
    M.targetWeather = nil
    M.transitionTime = 0
    M.currentTransitionTime = 0
    M.isTransitioning = false

    M.backgroundSkybox = nil
    M.foregroundSkybox = nil

    M.dirty = true
    if M.renderSteppedIns ~= nil then
        return
    end
    for _,weather in pairs(script.WeatherConfig.Children) do
        M.AddWeatherByTid(weather.Name)
    end

    M.renderSteppedIns = rs.RenderStepped:Connect(M.Update)
end

--删除默认的天空盒
function M.DeleteDefaultSkybox()
    local defaultSkybox = Workspace.Skybox
    if defaultSkybox then
        defaultSkybox:Destroy()
    end
end

--创建天空盒
function M.CreateSkybox(weatherPreset, opacity)
    local skybox = script.WeatherAsset[weatherPreset.skybox]
    -- print("skybox", skybox)
    if skybox then
        local newSkybox = skybox:Clone()
        newSkybox.Parent = Workspace
        newSkybox.LoadFinish:connect(function(suc)
            local mat = newSkybox:GetMaterialInstance({}, 0)
            if mat == nil then
                print("WeatherManager:CreateSkybox failed, mat is nil")
                newSkybox:Destroy()
                return nil
            end
            mat:SetR32("_Opaque", opacity)
        end)
        return newSkybox
    end
    return nil
end

--切换天气
function M.SwitchWeather(weatherName, transitionDuration)
    M.DeleteDefaultSkybox()
    local targetWeather = M.weatherList[weatherName]
    if not targetWeather then
        print("WeatherManager:SwitchWeather failed, weather not found: %s", tostring(weatherName))
        return
    end

    -- 如果目标天气与当前正在过渡的目标天气相同，则不需要重新切换
    if M.isTransitioning and M.targetWeather == targetWeather then
        return
    end

    if M.currentWeather == nil then
        M.currentWeather = targetWeather
        M.weatherData = targetWeather:GetWeatherData()
        if M.foregroundSkybox then
            M.foregroundSkybox:Destroy()
        end
        M.foregroundSkybox = M.CreateSkybox(targetWeather, 1.0)
        if M.foregroundSkybox then
            M.foregroundSkybox.Name = "ForegroundSkybox"
        end

        M.currentWeather.skyboxAlpha = 1
        M.dirty = true
        return
    end

    -- 如果正在过渡中，则以当前状态作为新的起始点
    if M.isTransitioning then
        local currentAlpha = M.weatherData.skyboxAlpha
        
        M.currentWeather = WeatherPreset.New()
        M.currentWeather:SetWeatherData(M.weatherData)
        
        if M.foregroundSkybox then
            M.foregroundSkybox:Destroy()
        end
        M.foregroundSkybox = M.backgroundSkybox
        M.backgroundSkybox = nil
        
        -- 创建新的背景天空盒，使用当前的alpha值
        M.backgroundSkybox = M.CreateSkybox(targetWeather, currentAlpha)
        
        -- 确保前景和背景天空盒的alpha值正确
        if M.foregroundSkybox then
            local foregroundMat = M.foregroundSkybox:GetMaterialInstance({}, 0)
            if foregroundMat then
                foregroundMat:SetR32("_Opaque", 1 - currentAlpha)
            end
        end
        
        if M.backgroundSkybox then
            local backgroundMat = M.backgroundSkybox:GetMaterialInstance({}, 0)
            if backgroundMat then
                backgroundMat:SetR32("_Opaque", currentAlpha)
            end
        end
    else
        -- 非过渡状态下的首次创建
        M.backgroundSkybox = M.CreateSkybox(targetWeather, 0.0)
    end

    M.targetWeather = targetWeather
    M.transitionTime = transitionDuration or 0
    M.currentTransitionTime = 0
    M.isTransitioning = true
    
    M.dirty = true
end

--获取天气
function M.GetWeather(weatherName)
    return M.weatherList[weatherName]
end

--添加天气
function M.AddWeatherByTid(tid)
    local weatherPreset = WeatherPreset.New()
    weatherPreset:LoadDataFromTid(tid)
    M.AddWeather(weatherPreset.name, weatherPreset)
end

--添加天气
function M.AddWeather(weatherName, weather)
    M.weatherList[weatherName] = weather
end

--移除天气
function M.RemoveWeather(weatherName)
    M.weatherList[weatherName] = nil
end

--获取天气列表
function M.GetWeatherList()
    return M.weatherList
end



function M.Update(dt)
    if M.isTransitioning then
        M.currentTransitionTime = M.currentTransitionTime + dt
        local t = math.min(1, M.currentTransitionTime / M.transitionTime)
        print("t", t)
        
        M.weatherData = M.currentWeather:Lerp(M.targetWeather, t)

        if M.currentTransitionTime >= M.transitionTime then
            M.isTransitioning = false
            M.currentWeather = M.targetWeather
            M.targetWeather = nil
            M.weatherData = M.currentWeather:GetWeatherData()
            -- print("transition finish2222")
        end
        -- print(ToString(M.weatherData))
        M.dirty = true
    end

    if M.dirty then
        M.UpdateDirectionalLight()
        M.UpdateFog()
        M.UpdateGlobalShaderParams()
        M.UpdateSkybox()
        M.UpdateEffect()
        --M:PrintWeatherData()
        M.dirty = false
    end
end
function M.WeatherDataToString()
    -- return Json.encode(M.weatherData)
    return ""
end

function M:PrintWeatherData()
    print("WeatherManager:PrintWeatherData " .. M.WeatherDataToString())
end

--更新方向光
function M.UpdateDirectionalLight()
    if M.weatherData == nil then
        return
    end
    if Workspace.Environment == nil then
        return
    end
    local SunLight = Workspace.Environment.SunLight
    if SunLight == nil then
        return
    end
    SunLight.LocalSyncFlag = Enum.NodeSyncLocalFlag.NO_SEND
    SunLight.Euler = M.weatherData.lightDirection
    SunLight.Intensity = M.weatherData.lightIntensity
    SunLight.Color = ColorQuad.New(M.weatherData.lightColor.X * 255, 
        M.weatherData.lightColor.Y * 255, 
        M.weatherData.lightColor.Z * 255, 
        M.weatherData.lightColor.W * 255)
end

--更新雾
function M.UpdateFog()
    if M.weatherData == nil then
        return
    end
    if Workspace.Environment == nil then
        return
    end
    local Atmosphere = Workspace.Environment.Atmosphere
    if Atmosphere == nil then
        return
    end
    Atmosphere.LocalSyncFlag = Enum.NodeSyncLocalFlag.NO_SEND
    Atmosphere.FogStart = M.weatherData.fogStart
    Atmosphere.FogEnd = M.weatherData.fogEnd
    Atmosphere.FogColor = ColorQuad.New(M.weatherData.fogColor.X * 255, 
        M.weatherData.fogColor.Y * 255, 
        M.weatherData.fogColor.Z * 255, 
        M.weatherData.fogColor.W * 255)
end

--更新全局着色器参数
function M.UpdateGlobalShaderParams()
    if M.weatherData == nil then
        return
    end
    MaterialService:SetGlobalFloat("gSnowAmount", M.weatherData.snowAmount)
    MaterialService:SetGlobalFloat("gWindStrength", M.weatherData.windStrength)
    MaterialService:SetGlobalFloat("gWetness", M.weatherData.wetness)
    -- MaterialService:SetGlobalVector("Weather_WindDirection", M.weatherData.windDirection)
end

--更新天空盒
function M.UpdateSkybox()
    if M.weatherData == nil then
        return
    end

    if M.backgroundSkybox == nil then
        return
    end

    if M.foregroundSkybox == nil then
        return
    end
    local backgroundMat = M.backgroundSkybox:GetMaterialInstance({}, 0)
    local foregroundMat = M.foregroundSkybox:GetMaterialInstance({}, 0)

    if backgroundMat == nil or foregroundMat == nil then
        return
    end

    backgroundMat:SetR32("_Opaque", M.weatherData.skyboxAlpha)
    foregroundMat:SetR32("_Opaque", 1 - M.weatherData.skyboxAlpha)

    if M.weatherData.skyboxAlpha >= 1 then
        M.foregroundSkybox:Destroy()
        M.foregroundSkybox = nil

        M.foregroundSkybox = M.backgroundSkybox
        M.backgroundSkybox = nil
    end
end

--更新效果
function M.UpdateEffect()
    if M.weatherData == nil then
        return
    end
end

function M.test()
    M.Init()

    Wait(2)
    M.SwitchWeather("Weather_1", 5)

    Wait(3)
    M.SwitchWeather("Weather_2", 5)

    Wait(15)
    M.SwitchWeather("Weather_1", 10)
end

return M