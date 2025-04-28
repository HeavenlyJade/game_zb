local WeaponPlantSlot = MS.Class.new("WeaponPlantSlot", MS.UIRootPrefabFunctionality)

function WeaponPlantSlot:ctor()
end

function WeaponPlantSlot:Init()
    self.weaponPlantSlot = self.owner.bindingUI
    self.weaponPlantFrame = self.weaponPlantSlot.WeaponPlantFrame
    self.healthBar = self.weaponPlantSlot.HealthBar
end

function WeaponPlantSlot:HealthUpdate(health, maxHealth)
    if self.healthBar.ProgressBar == nil then
        return
    end

    if health <= 0 then
        self.healthBar.ProgressBar.FillAmount = 0
    else
        self.healthBar.ProgressBar.FillAmount = health / maxHealth
    end
end

function WeaponPlantSlot:AmmoUpdate(ammo, ammoCarry)
	if self.weaponPlantFrame.PlantIcon == nil then
		return
	end
    if self.weaponPlantFrame.PlantIcon.Ammo.AmmoText == nil then
        return
    end
    self.weaponPlantFrame.PlantIcon.Ammo.AmmoText.Title = string.format("%d/%d", ammo, ammoCarry)
end

function WeaponPlantSlot:InstanceDieUpdate()
    if self.weaponPlantSlot == nil then
        return
    end
    self.weaponPlantSlot.Grayed = true
end

function WeaponPlantSlot:Update(eventName, ...)
    local slotIndex = select(1, ...)
    if eventName == "OnInitWeaponPlant" then
        if slotIndex ~= self.slotIndex then
            return
        end

        self.weaponPlantFrame.PlantIcon.Icon = _G.PlayerController.pawn.playerState.weaponPlantCards[slotIndex].icon
        self.weaponPlantSlot.Click:Connect(
            function()
                _G.PlayerController:OnSwitchWeapon(slotIndex)
            end
        )
    elseif eventName == "OnSwitchWeapon" then
        if slotIndex == self.slotIndex then
            self.weaponPlantFrame.Icon = "sandboxId://PVZ_UI/PlayerHUD/Bg_Battle_Plants_On.png"
        else
            self.weaponPlantFrame.Icon = "sandboxId://PVZ_UI/PlayerHUD/Bg_Battle_Plants_Off.png"
        end
    elseif eventName == "OnAttributeUpdate" then
        if slotIndex ~= self.slotIndex then
            return
        end
        local attribute = select(2, ...)
        if attribute == "Health" then
            local health = select(3, ...)
            local maxHealth = select(4, ...)
            self:HealthUpdate(health, maxHealth)
        end
        if attribute == "Ammo" then
            local ammo = select(3, ...)
            local ammoCarry = select(4, ...)
            self:AmmoUpdate(ammo, ammoCarry)
        end
        if attribute == "Level" then
            local level = select(3, ...)
            self.weaponPlantFrame.LevelNum.Title = "Lv." .. level
        end
    elseif eventName == "OnInstanceDieUpdate" then
        if slotIndex ~= self.slotIndex then
            return
        end
        self:InstanceDieUpdate()
    end
end

return WeaponPlantSlot
