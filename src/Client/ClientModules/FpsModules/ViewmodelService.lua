-- Do Weapon functionallities that relates to a viewmodel. (Needs input to work)
-- 12/19/2020
-- Minhnormal

local ViewmodelService = {}
ViewmodelService.__index = ViewmodelService

function ViewmodelService.new(weaponStorer)
    if not weaponStorer then return end

    local self = {}

    self.weaponStorer = weaponStorer
    self.viewmodel = nil
    self.currentWeapon = nil

    setmetatable(self, ViewmodelService)
    return self
end


function ViewmodelService:runViewmodel()
    -- Attach viewmodel to player's HumanoidRootPart (By RenderStepped Event)
end


function ViewmodelService:unequipWeapon()
    if not self.currentWeapon or not self.viewmodel then return end

    self.currentWeapon:Destroy()
    self.currentWeapon = nil

    self.viewmodel:Destroy()
    self.viewmodel = nil
end


function ViewmodelService:equipWeapon(weaponName)
    --[[Parameters
        weaponName: string
    ]]

    if not weaponName then return end

    local weapon = self.weaponStorer:FindFirstChild(weaponName)
    if not weapon then return end

    
    self:unequipWeapon()
    -- Make a new viewmodel equip weapon here, need to run it as well.
end

return ViewmodelService