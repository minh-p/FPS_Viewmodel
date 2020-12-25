-- Do Weapon functionallities that relates to a viewmodel. (Needs input to work)
-- 12/19/2020
-- Minhnormal

--[[
    How to use, as of 12/25/2020, every weapons must have PrimaryPart, which will be then sticked to the ViewModel when they are equipped.
]]

local PlayerScripts = game.Players.LocalPlayer.PlayerScripts
local clientModules = PlayerScripts.ClientModules

local RunService = game:GetService("RunService")

local ViewmodelService = {}
ViewmodelService.__index = ViewmodelService

function ViewmodelService.new(weaponStorer, viewmodelReference)

    --[[
        Paramters:
        weaponStorer: folder
        viewmodelReference: model
    ]]

    if not weaponStorer then return end
    if not viewmodelReference then return end
    if not viewmodelReference:IsA("Model") then return end

    local self = {}

    self.viewmodelSway = require(clientModules.FpsModules.ViewmodelSwayService).new()
    self.viewmodelAim = require(clientModules.FpsModules.ViewmodelAimService).new()

    self.weaponStorer = weaponStorer
    self.viewmodelReference = viewmodelReference
    self.viewmodel = nil
    self.currentWeapon = nil
    self.lastWeaponEquippedName = nil
    self.viewmodelRenderEvent = nil

    setmetatable(self, ViewmodelService)
    return self
end


function ViewmodelService:_getNewViewmodel()
    -- Clone a viewmodel via client
    if self.viewmodel then return end
    self.viewmodel = self.viewmodelReference:Clone()
end


function ViewmodelService:_runViewmodel()
    if not self.currentWeapon then return end
    if not self.viewmodel then return end
    self.viewmodel.Parent = workspace.CurrentCamera

    self.viewmodelSway:setupViewmodel(self.viewmodel)
    self.viewmodelAim:setup(self.viewmodel, self.currentWeapon)

    local placings = self.currentWeapon:FindFirstChild("Placing")
    if not placings then
        warn("Missing folder placings for weapon: " .. self.currentWeapon.Name)
        return
    end

    local viewmodelOffset = placings:FindFirstChild("ViewmodelOffset")
    if not viewmodelOffset then
        warn("Missing ViewmodelOffset for weapon: " .. self.currentWeapon.Name)
        return
    end

    local function moveViewmodel()
        local viewmodelSwayAnchorPoint = workspace.CurrentCamera.CFrame * viewmodelOffset.Value
        self.viewmodel.PrimaryPart.CFrame = viewmodelSwayAnchorPoint
        self.viewmodelSway:sway()
    end

    self.viewmodelRenderEvent = RunService.RenderStepped:Connect(moveViewmodel)

    self.viewmodelAim:enableAiming()
end


function ViewmodelService:_equip(weapon)

    --[[
        Paramters:
        weapon: model
    ]]

    if not weapon then return end

    self:_getNewViewmodel()

    if not self.viewmodel then return end

    local viewmodelGunAttach = self.viewmodel.PrimaryPart.GunAttach
    if not viewmodelGunAttach then return end

    local clonedWeapon = weapon:Clone()
    clonedWeapon.Parent = self.viewmodel

    viewmodelGunAttach.Part1 = clonedWeapon.PrimaryPart

    self.currentWeapon = clonedWeapon

    self:_runViewmodel()

    local weaponAnimations = self.currentWeapon:FindFirstChild("Animations")
    if weaponAnimations then
        local idleAnimation = weaponAnimations:FindFirstChild("Idle")
        if not idleAnimation then return end
        
        local animator = self.viewmodel.AnimationController:WaitForChild("Animator")
        local idleTrack = animator:LoadAnimation(idleAnimation)
        idleTrack:Play()
    end
end


function ViewmodelService:unequipWeapon()
    if not self.currentWeapon or not self.viewmodelRenderEvent or not self.viewmodel then return end

    self.lastWeaponEquippedName = self.currentWeapon.Name
    self.currentWeapon:Destroy()
    self.currentWeapon = nil

    self.viewmodelAim:disableAiming()
    self.viewmodelRenderEvent:Disconnect()
    self.viewmodelRenderEvent = nil

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

    if weaponName == self.lastWeaponEquippedName then
        -- If we reach this point, we now know that our last weapon equipped is now considered as nothing, so is its name.
        self.lastWeaponEquippedName = nil
        return    
    end

    self:_equip(weapon)
end

return ViewmodelService