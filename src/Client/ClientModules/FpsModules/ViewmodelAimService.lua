-- Makes the player be able to aim using ContextActionService, and changing The viewmodel offset.
-- 12/25/2020
-- Minhnormal

local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")

local ViewmodelAimService = {}
ViewmodelAimService.__index = ViewmodelAimService

ViewmodelAimService.aimInputs = {
    Enum.UserInputType.MouseButton2,
}

function ViewmodelAimService.new()
    local self = {}

    self.aimActionName = "Aiming"
    self.aimTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)

    self.viewmodel = nil
    self.currentWeapon = nil

    setmetatable(self, ViewmodelAimService)
    return self
end


function ViewmodelAimService:setup(newViewmodel, newCurrentWeapon)
    if not newViewmodel then return end
    if not newViewmodel:IsA("Model") then return end
    self.viewmodel = newViewmodel

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
        if not viewmodelOffset then warn("No Viewmodel Offset in Folder Placings in Weapon.") return end

        local aimOffset = placings:FindFirstChild("AimOffset")
        if not aimOffset then warn("No aim offset in Folder Placings in Weapon.") return end

        local defaultOffset = placings:FindFirstChild("DefaultOffset")
        if not defaultOffset then warn("No default offset in Folder Placings in Weapon.") return end

        local aimTween
        local stopAimTween

        if inputState == Enum.UserInputState.Begin then
            -- Tween Viewmodel Offset to Aim offset.
            if stopAimTween then stopAimTween:Stop() stopAimTween = nil end
            aimTween = TweenService:Create(viewmodelOffset, self.aimTweenInfo, {Value = aimOffset.Value})
            aimTween:Play()
        end

        if inputState == Enum.UserInputState.End then
            -- Tween Viewmodel Offset back to the default offset.
            if aimTween then aimTween:Stop() aimTween = nil end
            stopAimTween = TweenService:Create(viewmodelOffset, self.aimTweenInfo, {Value = defaultOffset.Value})
            stopAimTween:Play()
        end
    end

    ContextActionService:BindAction(self.aimActionName, handleAiming, true, table.unpack(self.aimInputs))
end


function ViewmodelAimService:disableAiming()
    ContextActionService:UnbindAction(self.aimActionName)
end

return ViewmodelAimService