-- Makes FPS ViewModel sways when it is moved from left to right.
-- 12/23/2020
-- Minhnormal

local UserInputService = game:GetService("UserInputService")

local ViewmodelSwayService = {}
ViewmodelSwayService.__index = ViewmodelSwayService

function ViewmodelSwayService.new()
    local self = {}

    self.viewmodel = nil
    self.multiplier = 10

    setmetatable(self, ViewmodelSwayService)
    return self
end


function ViewmodelSwayService:setupViewmodel(viewmodel)
    --[[
        Parameters:
        viewmodel: Model
    ]]
    
    self.viewmodel = viewmodel
end


function ViewmodelSwayService:sway()
    if not self.viewmodel then return end

    local mouseDelta = UserInputService:GetMouseDelta()

    local swayOffset = self.lastSwayOffset or CFrame.Angles(0, 0, 0)

    swayOffset = swayOffset:Lerp(CFrame.Angles(0, math.sin(mouseDelta.X/100) * self.multiplier, math.sin(mouseDelta.Y/100) * self.multiplier), 0.1)

    self.viewmodel.PrimaryPart.CFrame *= swayOffset
    self.lastSwayOffset = swayOffset
end

return ViewmodelSwayService