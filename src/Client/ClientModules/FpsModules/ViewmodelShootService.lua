-- Enable the ability to fire weapons (on the viewmodel).
-- 12/26/2020
-- Minhnormal

local ContextActionService = game:GetService("ContextActionService")
local Debris = game:GetService("Debris")

local PlayerScripts = game.Players.LocalPlayer.PlayerScripts
local clientModules = PlayerScripts.ClientModules

local ViewmodelFiringService = {}
ViewmodelFiringService.__index = ViewmodelFiringService

function ViewmodelFiringService.new()
    local self = {}

    self.firingInputs = {
        Enum.UserInputType.MouseButton1
    }

    self.recoil = require(clientModules.FpsModules.RecoilService).new()

    self.firingActionName = "WeaponFire"

    self.viewmodel = nil
    self.currentWeapon = nil

    self.canFire = true
    self.firing = false

    setmetatable(self, ViewmodelFiringService)
    return self
end


function ViewmodelFiringService:setup(viewmodel, currentWeapon)

    --[[
        Parameters:
        viewmodel: Model
        currentWeapon: Model
    ]]

   if not viewmodel then return end
   if not viewmodel:IsA("Model") then return end
   
   if not currentWeapon then return end
   if not currentWeapon:IsA("Model") then return end

   self.viewmodel = viewmodel
   self.currentWeapon = currentWeapon
end


function ViewmodelFiringService:_getGunRPM()
    return 600
end


function ViewmodelFiringService:_shootWeapon()
    if not self.viewmodel then return end
    if not self.currentWeapon then return end

    local sounds = self.currentWeapon:FindFirstChild("Sounds")
    if sounds then
        local shootingSound = sounds:FindFirstChild("Fired")
        if shootingSound then
            local clonedShootingSound = shootingSound:Clone()
            clonedShootingSound.Parent = self.currentWeapon.PrimaryPart
            clonedShootingSound:Play()

            Debris:AddItem(clonedShootingSound, 5)
        end
    end

    coroutine.resume(coroutine.create(function ()
        local weaponBarrel = self.currentWeapon:FindFirstChild("Barrel") or self.currentWeapon.PrimaryPart
        if not weaponBarrel then return end
    
        local muzzleFlash = weaponBarrel:FindFirstChild("Flash")
        if muzzleFlash then
            muzzleFlash.Transparency = NumberSequence.new(muzzleFlash._Transparency.Value)
            wait()
            muzzleFlash.Transparency = NumberSequence.new(1)
        end
    end))

    self.recoil:applyRecoil()
end


function ViewmodelFiringService:_bindFiring()
    local function handleFiring(_, inputState)
        if inputState == Enum.UserInputState.Begin then
            if self.canFire == false then return end
            self.firing = true

            self.canFire = false
            self:_shootWeapon()
            self.canFire = true

            local configurations = self.currentWeapon:FindFirstChild("Configurations")
            if not configurations then return end
            
            local automatic = configurations:FindFirstChild("Automatic")
            if not automatic then return end

            if automatic.Value == true and self.firing == true then
                local gunRPM = self:_getGunRPM()

                repeat
                    self.canFire = false
                    self:_shootWeapon()
                    wait(60/gunRPM)
                    self.canFire = true
                until not self.firing
            end
        end

        if inputState == Enum.UserInputState.End then
            self.firing = false
        end
    end

    ContextActionService:BindAction(self.firingActionName, handleFiring, true, table.unpack(self.firingInputs))
end


function ViewmodelFiringService:enableFiring()
    self:_bindFiring()
end


function ViewmodelFiringService:disableShooting()
    ContextActionService:UnbindAction(self.firingActionName)
end

return ViewmodelFiringService