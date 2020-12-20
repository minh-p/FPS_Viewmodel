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
    [1] = "",
    [2] = "",
    [3] = "",
}

function ClientWeaponService.new(weaponStorer)

    --[[
        Parameters:
        weaponStorer: RobloxFolder
    ]]

    local self = {}

    self.viewmodelService = require(clientModules.FpsModules.ViewmodelService).new(weaponStorer)

    setmetatable(self, ClientWeaponService)
    return self
end


function ClientWeaponService:bindEquipViewmodelWeapon()
    ContextActionService:BindAction(function()
        self.viewmodelService:equipWeapon()
    end)
end


function ClientWeaponService:bindUnequipViewmodelWeapon()
    ContextActionService:BindAction(function()
        self.viewmodel:unequipWeapon()
    end)
end

return ClientWeaponService