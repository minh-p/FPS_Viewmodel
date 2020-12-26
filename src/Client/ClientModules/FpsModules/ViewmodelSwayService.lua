-- Makes FPS ViewModel sways when it is moved from left to right.
-- 12/23/2020
-- Minhnormal

local UserInputService = game:GetService("UserInputService")

local ViewmodelSwayService = {}
ViewmodelSwayService.__index = ViewmodelSwayService

function ViewmodelSwayService.new()
    local self = {}

    self.aimingMultipler = 5
    self.notAimingMultiplier = 10

    self.swayXAimingLimit = 0.1
    self.swayXNotAimingLimit = 1

    self.swayYAimingLimit = 0.005
    self.swayYNotAimingLimit = 0.1

    self.multiplier = 10
    
    self.swayXLimit = 0
    self.swayYLimit = 0

    self.viewmodel = nil

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


function ViewmodelSwayService:_handleMultiplier(aiming)

    --[[
        Parameters:
        aiming: Bool
    ]]

    if aiming then
        self.multiplier = self.aimingMultipler
    else
        self.multiplier = self.notAimingMultiplier
    end
end


function ViewmodelSwayService:_handleSwayLimiter(aiming)
    if aiming then
        self.swayXLimit = self.swayXAimingLimit
        self.swayYLimit = self.swayYAimingLimit
    else
        self.swayXLimit = self.swayXNotAimingLimit
        self.swayYLimit = self.swayYNotAimingLimit
    end
end


function ViewmodelSwayService:_applySwayLimiter(swayX, swayY)
    local limitedSwayX = swayX
    if swayX > self.swayXLimit then limitedSwayX = self.swayXLimit end
    if swayX < -self.swayXLimit then limitedSwayX = -self.swayXLimit end

    local limitedSwayY = swayY
    if swayY > self.swayYLimit then limitedSwayY = self.swayYLimit end
    if swayY < -self.swayYLimit then limitedSwayY = -self.swayYLimit end

    return limitedSwayX, limitedSwayY
end


function ViewmodelSwayService:sway(aiming)

    --[[
        Parameters:
        aiming: Bool
    ]]

    if not self.viewmodel then return end

    self:_handleMultiplier(aiming)
    self:_handleSwayLimiter(aiming)

    local mouseDelta = UserInputService:GetMouseDelta()

    local swayOffset = self.lastSwayOffset or CFrame.Angles(0, 0, 0)

    local swayX = math.sin(mouseDelta.X/100)
    local swayY = math.sin(mouseDelta.Y/100)

    local limitedSwayX, limitedSwayY = self:_applySwayLimiter(swayX, swayY)

    swayOffset = swayOffset:Lerp(CFrame.Angles(0, limitedSwayX * self.multiplier, limitedSwayY * self.multiplier), 0.1)

    self.viewmodel.PrimaryPart.CFrame *= swayOffset
    self.lastSwayOffset = swayOffset
end

return ViewmodelSwayService