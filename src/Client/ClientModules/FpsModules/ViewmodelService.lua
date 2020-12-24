-- Do Weapon functionallities that relates to a viewmodel. (Needs input to work)
-- 12/19/2020
-- Minhnormal

--[[
    How to use, currently of 12/20/2020
    The gun need to primary part as an object named "GunAttach", for this to work.
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
    -- Attach viewmodel to player's HumanoidRootPart (By RenderStepped Event)
    if not self.viewmodel then return end
    self.viewmodel.Parent = workspace.CurrentCamera

    self.viewmodelSway:setupViewmodel(self.viewmodel)

    local function moveViewmodel()
        -- CFrame.new(Vector3.new(0, -1, 0)) * CFrame.Angles(0, math.pi/2, 0)
        local viewmodelSwayAnchorPoint = workspace.CurrentCamera.CoordinateFrame * CFrame.new(Vector3.new(0, -1, 0)) * CFrame.Angles(0, math.pi/2 , 0)
        -- This function right here will sway the weapon, as well as offsetting it.
        
        self.viewmodelSway:sway(viewmodelSwayAnchorPoint)
    end

    self.viewmodelRenderEvent = RunService.RenderStepped:Connect(moveViewmodel)
end


function ViewmodelService:_equip(weapon)

    --[[
        Paramters:
        weapon: model
    ]]

    if not weapon then return end
    if not self.viewmodel then return end

    local viewmodelGunAttach = self.viewmodel.PrimaryPart.GunAttach
    if not viewmodelGunAttach then return end

    local clonedWeapon = weapon:Clone()
    clonedWeapon.Parent = self.viewmodel

    viewmodelGunAttach.Part1 = clonedWeapon.GunAttach

    self.currentWeapon = clonedWeapon

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
        -- If we reach this point, we now know that our last weapon equipped is now considered as nothing.
        self.lastWeaponEquippedName = nil
        return    
    end

    self:_getNewViewmodel()
    self:_runViewmodel()
    self:_equip(weapon)
end

return ViewmodelService