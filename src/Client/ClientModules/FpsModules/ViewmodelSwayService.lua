-- Makes FPS ViewModel sways when it is moved from left to right.
-- 12/23/2020
-- Minhnormal

local UserInputService = game:GetService("UserInputService")

local ViewmodelSwayService = {}
ViewmodelSwayService.__index = ViewmodelSwayService

function ViewmodelSwayService.new()
    local self = {}

    self.viewmodel = nil
    self.lastAnchorPoint = nil
    self.swayOffset = nil
    self.multiplier = 10
    self.camera = workspace.CurrentCamera

    setmetatable(self, ViewmodelSwayService)
    return self
end


function ViewmodelSwayService:setupViewmodel(viewmodel)
    self.viewmodel = viewmodel
end


function ViewmodelSwayService:sway(anchorPoint)
    if not self.viewmodel then return end

    local mouseDelta = UserInputService:GetMouseDelta()

    local swayOffset = CFrame.Angles(math.sin(mouseDelta.X/50), 0, math.sin(mouseDelta.Y/50))
    local lerpToCFrame = anchorPoint * swayOffset

    local newViewmodelCFrame = anchorPoint

    if self.lastAnchorPoint then
        newViewmodelCFrame = self.lastAnchorPoint:Lerp(lerpToCFrame, 0.1)
    end

    self.viewmodel.PrimaryPart.CFrame = newViewmodelCFrame
    self.lastAnchorPoint = newViewmodelCFrame
end

return ViewmodelSwayService