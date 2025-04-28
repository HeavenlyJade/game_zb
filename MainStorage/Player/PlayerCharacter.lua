local PlayerCharacter = MS.Class.new("PlayerCharacter")

-- SceneInstances Infos stored in ClientSide
function PlayerCharacter:ctor()
    self.controller = nil

    self.possessedWeaponPlantInstances = {}
    self.controlledWeaponPlantInstance = nil
    self.cameraController = nil

    self.playerState = MS.PlayerState.new()
end

function PlayerCharacter:Init()
    self.cameraController = MS.CameraController.new()
    self.cameraController:Init()
end

function PlayerCharacter:PossessWeaponPlant(weaponPlantInstances)
    self.possessedWeaponPlantInstances = weaponPlantInstances
end

function PlayerCharacter:SwitchWeaponPlant(weaponPlantIndex)
    local weaponPlantInstance = self.possessedWeaponPlantInstances[weaponPlantIndex]
    if weaponPlantInstance ~= nil then
        if weaponPlantInstance ~= self.controlledWeaponPlantInstance then
            self.controlledWeaponPlantInstance:UnAttachCameraComponent()
            self.controlledWeaponPlantInstance = weaponPlantInstance
            self.controlledWeaponPlantInstance:AttachCameraComponent(self.cameraController)
        end
    end
end

return PlayerCharacter
