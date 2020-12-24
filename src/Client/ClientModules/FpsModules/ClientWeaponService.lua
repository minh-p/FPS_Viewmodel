-- Client Framework for Fps viewmodel
-- 22/9/2020
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
    [2] = "ARClone",
    [3] = nil,
}

function ClientWeaponService.new(weaponStorer, viewmodelReference)

    --[[
        Parameters:
        weaponStorer: RobloxFolder
        viewmodelReference: The original viewmodel in ReplicatedStorage.Objects
    ]]

    local self = {}

    self.viewmodelService = require(clientModules.FpsModules.ViewmodelService).new(weaponStorer, viewmodelReference)

    setmetatable(self, ClientWeaponService)
    return self
end


function ClientWeaponService:bindEquipViewmodelWeapons()
    for count, _ in ipairs(self.currentPlayerWeaponNames) do
        local currentEnumBind = self.enumBinds[count]
        local currentPlayerWeaponName = self.currentPlayerWeaponNames[count]
    
        local function handleEquipWeapon(_, inputState)
            if inputState == Enum.UserInputState.Begin then
                print("equipped")
                self.viewmodelService:equipWeapon(currentPlayerWeaponName)
            end
        end
    
        ContextActionService:BindAction("EquipWeaponSlot " .. tostring(count), handleEquipWeapon, false, Enum.KeyCode[currentEnumBind])
    end
end

return ClientWeaponService