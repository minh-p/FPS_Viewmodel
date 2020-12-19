-- Client Framework for Fps viewmodel
-- 12/9/2020
-- Minhnormal

local ContextActionService = game:GetService("ContextActionService")

local ClientGunService = {}
ClientGunService.__index = ClientGunService

ClientGunService.enumBinds = {
    [1] = "One",
    [2] = "Two",
    [3] = "Three"
}

ClientGunService.currentWeapon = nil

function ClientGunService.new()
    local self = {}
    setmetatable(self, ClientGunService)
    return self
end


function ClientGunService:bindEquipViewmodelGun()
    ContextActionService:BindAction(function()
        
    end)
end


function ClientGunService:bindUnequipViewmodelGun()
    ContextActionService:BindAction(function()
        
    end)
end

return ClientGunService