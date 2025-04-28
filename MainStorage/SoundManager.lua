local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local M = {}

M.SoundId_UIClick = 1

M.SoundId_HallBackground = 2
M.SoundId_BattleBackground = 3

M.SoundId_Boom = 4
M.SoundId_ResultDefeat = 5
M.SoundId_ResultWin = 6
M.SoundId_BattleBegin = 7
M.SoundId_ZombieComing = 8
M.SoundId_ZombieFired = 9

M.SoundStatus_Playing = 1
M.SoundStatus_NotPlay = 2
M.SoundStatus_Pause = 3

M.SoundAssets = {
    {
        ['id'] = M.SoundId_UIClick,
        ['res'] = "sandboxId://PVZ_AU/BGM/ClickUI.mp3",
    },
    {
        ['id'] = M.SoundId_HallBackground,
        ['res'] = "sandboxId://PVZ_AU/BGM/ShootHallBGM.mp3",
    },
    {
        ['id'] = M.SoundId_BattleBackground,
        ['res'] = "sandboxId://PVZ_AU/BGM/BattleBGM.mp3",
    },
    {
        ['id'] = M.SoundId_Boom,
        ['res'] = "sandboxId://PVZ_AU/BGM/boom.mp3",
    },
    {
        ['id'] = M.SoundId_ResultDefeat,
        ['res'] = "sandboxId://PVZ_AU/BGM/Defeate.mp3",
    },
    {
        ['id'] = M.SoundId_ResultWin,
        ['res'] = "sandboxId://PVZ_AU/BGM/WIN.mp3",
    },
    {
        ['id'] = M.SoundId_BattleBegin,
        ['res'] = "sandboxId://PVZ_AU/BGM/Gamebegin.mp3",
    },
    {
        ['id'] = M.SoundId_ZombieComing,
        ['res'] = "sandboxId://PVZ_AU/BGM/Zombiecome.mp3",
    },
    {
        ['id'] = M.SoundId_ZombieFired,
        ['res'] = "sandboxId://PVZ_AU/BGM/Combustion.mp3",
    },
}

M.SoundIdAssetMap = {}
for i,v in ipairs(M.SoundAssets) do
    M.SoundIdAssetMap[v['id']] = v
end

M.sounds = {}

function M.GetSoundPath(id)
    local config = M.SoundIdAssetMap[id]
    if config == nil then
        print("not found correct Sound Path: ", id)
        return ""
    end
    return config.res
end

M.playId = 0
function M.GenPlayId()
    M.playId = M.playId + 1
    return M.playId
end

function M.ReplaceBackground(id, isLoop, volume)
    M.RemoveAllBackground()
    return M.PlayBackground(id, isLoop, volume)
end

function M.PlayBackground(id, isLoop, volume)
    local playIds = {}
    for playId,v in pairs(M.sounds) do
        if v[1] == id then
            playIds[#playIds+1] = playId
        end
    end
    for _,playId in ipairs(playIds) do
        M.Remove(playId)
    end
    if id == nil then
        id = M.SoundId_Background1
    end
    if isLoop == nil then
        isLoop = true
    end
    if volume == nil then
        volume = 1.0
    end
    if volume > 1.0 then
        volume = 1.0
    elseif volume < 0.0 then
        volume = 0.0
    end

    local sound = SandboxNode.new('Sound', M.sound_group)
    sound.SoundPath = M.GetSoundPath(id)
    sound.IsLoop = isLoop
    sound.Volume = volume
    sound:PlaySound()
    local playId = M.GenPlayId()
    M.sounds[playId] = {id, sound, M.SoundStatus_Playing, isLoop, volume}
    print("play sound", sound.SoundPath, id, sound, M.SoundStatus_Playing, isLoop, volume)
    return playId
end

function M.Play(id, isLoop, delayDestroyMs, volume)
    if id == nil then
        return
    end
    if volume == nil then
        volume = 1.0
    end
    if volume > 1.0 then
        volume = 1.0
    elseif volume < 0.0 then
        volume = 0.0
    end

    if isLoop == nil then
        isLoop = true
    end
    if not isLoop then
        if delayDestroyMs == nil then
            delayDestroyMs = 3000
        end
    end
    local sound = SandboxNode.new('Sound', M.sound_group)
    sound.SoundPath = M.GetSoundPath(id)
    sound.IsLoop = isLoop
    sound.Volume = volume
    sound:PlaySound()
    local playId = M.GenPlayId()
    if delayDestroyMs == nil then
        M.sounds[playId] = {id, sound, M.SoundStatus_Playing, isLoop, volume}
    else
        local curMs = RunService:CurrentMilliSecondTimeStamp()
        M.sounds[playId] = {id, sound, M.SoundStatus_Playing, isLoop, volume, curMs + delayDestroyMs}
    end
    print("play sound", sound.SoundPath, id, sound, M.SoundStatus_Playing, isLoop, volume)
    return playId
end

function M.GetSoundItem(playId)
    return M.sounds[playId]
end

function M.SetVolume(playId, value)
    local item = M.GetSoundItem(playId)
    item[2].Volume = value
    item[5] = value
end

function M.Stop(playId)
    local item = M.GetSoundItem(playId)
    item[2]:StopSound()
    item[3] = M.SoundStatus_NotPlay
end

function M.Pause(playId)
    local item = M.GetSoundItem(playId)
    item[2]:PauseSound()
    item[3] = M.SoundStatus_Pause
end

function M.Resume(playId)
    local item = M.GetSoundItem(playId)
    item[2]:ResumeSound()
    item[3] = M.SoundStatus_Playing
end

function M.Remove(playId)
    local item = M.GetSoundItem(playId)
    if item == nil then
        return
    end
    item[2]:Destroy()
    M.sounds[playId] = nil
end

function M.RemoveAllBackground()
    local removePlayIds = {}
    for playId, item in pairs(M.sounds) do
        local soundId = item[1]
        if soundId == M.SoundId_HallBackground or soundId == M.SoundId_BattleBackground then
            removePlayIds[#removePlayIds+1] = playId
        end
    end
    for i,playId in ipairs(removePlayIds) do
        M.Remove(playId)
    end
end

function M.Update()
    local curMs = RunService:CurrentMilliSecondTimeStamp()
    local removePlayIds = {}
    for playId, item in pairs(M.sounds) do
        if item[3] == M.SoundStatus_Playing and item[4] == false then
            local removeSoundMs = item[6]
            if removeSoundMs ~= nil then
                if curMs > removeSoundMs then
                    removePlayIds[#removePlayIds+1] = playId
                end
            end
        end
    end
    for i,playId in ipairs(removePlayIds) do
        M.Remove(playId)
    end
end


function M.Init()
    M.sound_group = SandboxNode.new('SoundGroup')
    M.sound_group.LocalSyncFlag = Enum.NodeSyncLocalFlag.DISABLE
    M.sound_group.Name = 'SoundGroup'
    M.sound_group.Parent = Workspace

    M.renderSteppedIns = RunService.RenderStepped:Connect(M.Update)
end

function M.BindCommonBtnSound()
    local btnTemplateSound = script.CommonBtnSound
    -- local LobbyUIRoot = Workspace.LobbyUIRoot
    -- local GameGardenUIRoot = Workspace.GameGardenUIRoot
    -- local TopBarBg = GameGardenUIRoot.TopBarBg
    local btns = {
        -- GameGardenUIRoot.Close,
        -- TopBarBg.Big,
        -- TopBarBg.Small,
        -- TopBarBg.Label1.UIButton,
        -- TopBarBg.Label2.UIButton,
        -- TopBarBg.Label3.UIButton,
        -- TopBarBg.Label4.UIButton,
        -- LobbyUIRoot.Attack,
        -- LobbyUIRoot.GameGarden,
        -- LobbyUIRoot.Jump,
        -- LobbyUIRoot.PlantParty,
        -- LobbyUIRoot.Run,
        -- LobbyUIRoot.SelectedPlant,
        -- LobbyUIRoot.SelectedSW,
        -- LobbyUIRoot.UserGemstone,
        -- Workspace.PlantPartyUIRoot.Close,
    }
    for i,btn in ipairs(btns) do
        print(i, btn)
        btn.Release = nil
        btn.Press = btnTemplateSound
    end
end

return M