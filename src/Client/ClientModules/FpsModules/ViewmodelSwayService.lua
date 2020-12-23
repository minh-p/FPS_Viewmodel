-- Makes FPS ViewModel sways when it is moved from left to right.
-- 12/23/2020
-- Minhnormal

local UserInputService = game:GetService("UserInputService")

local ViewmodelSwayService = {}
ViewmodelSwayService.__index = ViewmodelSwayService

function ViewmodelSwayService.new()
    local self = {}

    self.viewmodel = nil

    setmetatable(self, ViewmodelSwayService)
    return self
end


function ViewmodelSwayService:setupViewmodel(viewmodel)
    self.viewmodel = viewmodel
end


function ViewmodelSwayService:sway(anchorPoint)
    if not self.viewmodel then return end
    local viewmodelAnchorPoint = anchorPoint or workspace.CurrentCamera.CoordinateFrame

    local mouseDelta = UserInputService:GetMouseDelta()
    local mouseDeltaX = mouseDelta.X
    local mouseDeltaY = mouseDelta.Y

    self.viewmodel.PrimaryPart.CFrame = viewmodelAnchorPoint * CFrame.Angles(mouseDeltaX / 200, mouseDeltaY / 200, 0)
end

return ViewmodelSwayService