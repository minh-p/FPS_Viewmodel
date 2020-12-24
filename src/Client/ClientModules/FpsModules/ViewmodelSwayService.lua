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

    local rotation = anchorPoint
    
    if self.lastAnchorPoint then
        rotation = rotation:ToObjectSpace(self.lastAnchorPoint)
    end

    local x, y, _ = rotation:ToOrientation()

    local swayOffset = self.swayOffset or CFrame.Angles(0, 0, 0)
    swayOffset = swayOffset:Lerp(CFrame.Angles(math.sin(x) * self.multiplier, math.sin(y) * self.multiplier, 0), 0.1)

    self.viewmodel.PrimaryPart.CFrame = anchorPoint * swayOffset

    self.lastAnchorPoint = anchorPoint
    self.swayOffset = swayOffset
end

return ViewmodelSwayService