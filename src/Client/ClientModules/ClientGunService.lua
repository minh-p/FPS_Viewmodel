-- Client Framework for Fps viewmodel
-- 12/9/2020
-- Minhnormal

local ClientGunService = {}
ClientGunService.__index = ClientGunService

function ClientGunService.new()
    local self = {}
    setmetatable(self, ClientGunService)
    return self
end


function ClientGunService:bindEquipViewmodelGun()
    
end


function ClientGunService:bindUnequipViewmodelGun()
    
end

return ClientGunService