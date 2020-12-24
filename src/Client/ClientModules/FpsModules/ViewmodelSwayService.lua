-- Makes FPS ViewModel sways when it is moved from left to right.
-- 12/23/2020
-- Minhnormal

local ViewmodelSwayService = {}
ViewmodelSwayService.__index = ViewmodelSwayService

function ViewmodelSwayService.new()
    local self = {}

    self.viewmodel = nil
    self.lastAnchorPoint = nil
    self.swayOffset = nil
    self.multiplier = 3

    setmetatable(self, ViewmodelSwayService)
    return self
end


function ViewmodelSwayService:setupViewmodel(viewmodel)
    self.viewmodel = viewmodel
end


function ViewmodelSwayService:sway(anchorPoint)
    if not self.viewmodel then return end

    local toAnchorPoint = anchorPoint

    local swayOffset = self.swayOffset or CFrame.Angles(0, 0, 0)

    if self.lastAnchorPoint then
        local newAnchorPointPosition = toAnchorPoint:ToObjectSpace(self.lastAnchorPoint).Position

        -- Get the sway offset at rotation value which will be later multiplied to.
        local newAnchorPointRotation = toAnchorPoint:ToObjectSpace(self.lastAnchorPoint)
        local rX, rY = newAnchorPointRotation:ToOrientation()
        swayOffset = swayOffset:Lerp(CFrame.Angles(math.sin(rX) * self.multiplier, math.sin(rY) * self.multiplier, 0), 0.1)

        toAnchorPoint = self.lastAnchorPoint:Lerp(CFrame.new(anchorPoint.Position) * swayOffset, 0.1)
    end

    self.viewmodel.PrimaryPart.CFrame = toAnchorPoint

    self.lastAnchorPoint = anchorPoint
    self.swayOffset = swayOffset
end

return ViewmodelSwayService