-- Makes the player be able to aim using ContextActionService, and changing The viewmodel offset.
-- 12/25/2020
-- Minhnormal

local ContextActionService = game:GetService("ContextActionService")

local ViewmodelAimService = {}
ViewmodelAimService.__index = ViewmodelAimService

ViewmodelAimService.aimInputs = {
    Enum.UserInputType.MouseButton2,
}

function ViewmodelAimService.new()
    local self = {}

    self.aimActionName = "Aiming"

    self.currentWeapon = nil

    setmetatable(self, ViewmodelAimService)
    return self
end


function ViewmodelAimService:setupCurrentWeapon(newCurrentWeapon)
    if not newCurrentWeapon then return end
    if not newCurrentWeapon:IsA("Model") then return end
    self.currentWeapon = newCurrentWeapon
end


function ViewmodelAimService:_changeViewmodelOffset()
    
end


function ViewmodelAimService:enableAiming()
    local function handleAiming(_, inputState, _)
        if not self.currentWeapon then return end

        local placings = self.currentWeapon:FindFirstChild("Placing")
        if not placings then warn("No Folder Placings in current weaponl.") return end

        local viewmodelOffset = placings:FindFirstChild("ViewmodelOffset")
        if not viewmodelOffset then return end

        local aimOffset = placings:FindFirstChild("AimOffset")
        if not aimOffset then return end

        local defaultOffset = placings:FindFirstChild("DefaultOffset")
        if not defaultOffset then return end

        if inputState == Enum.UserInputState.Begin then
            -- Tween Viewmodel Offset to Aim offset.
        end

        if inputState == Enum.UserInputState.End then
            -- Tween Viewmodel Offset back to the default offset.
        end
    end

    ContextActionService:BindAction(self.aimActionName, handleAiming, true, table.unpack(self.aimInputs))
end


function ViewmodelAimService:disableAiming()
    ContextActionService:UnbindAction(self.aimActionName)
end

return ViewmodelAimService