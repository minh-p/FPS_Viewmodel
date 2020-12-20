-- Do Weapon functionallities that relates to a viewmodel. (Needs input to work)
-- 12/19/2020
-- Minhnormal

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

    self.weaponStorer = weaponStorer
    self.viewmodelReference = viewmodelReference
    self.viewmodel = nil
    self.currentWeapon = nil
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
    self.viewmodel.Parent = workspace

    self.viewmodelRenderEvent = RunService.RenderStepped:Connect(function()
        self.viewmodel:SetPrimaryPartCFrame(workspace.CurrentCamera.CFrame)
    end)
end


function ViewmodelService:_equip(weapon)

    --[[
        Paramters:
        weapon: model
    ]]

    if not weapon then return end
    if not self.viewmodel then return end

    local clonedWeapon = weapon:Clone()
    clonedWeapon.Parent = workspace

    local viewmodelGunAttach = self.viewmodel.RootPart.GunAttach
    viewmodelGunAttach.Part1 = clonedWeapon.GunAttach

    self.currentWeapon = clonedWeapon
end


function ViewmodelService:unequipWeapon()
    if not self.currentWeapon or not self.viewmodelRenderEvent or not self.viewmodel then return end

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

    self:_getNewViewmodel()
    self:_runViewmodel()
    self:_equip(weapon)
end

return ViewmodelService