-- Enable the ability to fire weapons (on the viewmodel).
-- 12/26/2020
-- Minhnormal

local ContextActionService = game:GetService("ContextActionService")

local ViewmodelFiringService = {}
ViewmodelFiringService.__index = ViewmodelFiringService

function ViewmodelFiringService.new()
    local self = {}

    self.firingInputs = {
        Enum.UserInputType.MouseButton1
    }

    self.firingActionName = "WeaponFire"

    self.viewmodel = nil
    self.currentWeapon = nil

    setmetatable(self, ViewmodelFiringService)
    return self
end


function ViewmodelFiringService:setup(viewmodel, currentWeapon)

    --[[
        Parameters:
        viewmodel: Model
        currentWeapon: Model
    ]]

   if not viewmodel then return end
   if not viewmodel:IsA("Model") then return end
   
   if not currentWeapon then return end
   if not currentWeapon:IsA("Model") then return end

   self.viewmodel = viewmodel
   self.currentWeapon = currentWeapon
end


function ViewmodelFiringService:_bindFiring()
    local function handleFiring()
        
    end

    ContextActionService:BindAction(self.firingActionName, handleFiring, true, table.unpack(self.firingInputs))
end


function ViewmodelFiringService:enableFiring()
    self:_bindFiring()
end


function ViewmodelFiringService:disableFiring()
    ContextActionService:UnbindAction(self.firingActionName)
end

return ViewmodelFiringService