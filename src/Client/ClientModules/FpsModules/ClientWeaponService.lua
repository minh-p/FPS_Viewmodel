-- Client Framework for Fps viewmodel
-- 12/9/2020
-- Minhnormal

local ContextActionService = game:GetService("ContextActionService")

local clientModules = game.Players.LocalPlayer.PlayerScripts.ClientModules

local ClientWeaponService = {}
ClientWeaponService.__index = ClientWeaponService

ClientWeaponService.enumBinds = {
    [1] = "One",
    [2] = "Two",
    [3] = "Three",
}


ClientWeaponService.currentPlayerWeaponNames = {
    [1] = "AR",
    [2] = "",
    [3] = "",
}

function ClientWeaponService.new(weaponStorer, viewmodelReference)

    --[[
        Parameters:
        weaponStorer: RobloxFolder
    ]]

    local self = {}

    self.viewmodelService = require(clientModules.FpsModules.ViewmodelService).new(weaponStorer, viewmodelReference)

    setmetatable(self, ClientWeaponService)
    return self
end


function ClientWeaponService:bindEquipViewmodelWeapons()
    for count = 1, #self.currentPlayerWeaponNames do
        local function handleEquipWeapon(actionName, inputState)
            if actionName ~= "EquipWeapon" then return end
            if inputState == Enum.UserInputState.End then
                self.viewmodelService:equipWeapon(self.currentPlayerWeaponNames[count])
            end
        end

        local currentEnumBind = self.enumBinds[count]
        ContextActionService:BindAction("EquipWeapon", handleEquipWeapon, false, Enum.KeyCode[currentEnumBind])
    end
end

return ClientWeaponService