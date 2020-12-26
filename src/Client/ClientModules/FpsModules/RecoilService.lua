-- Add recoil to Camera, which emulates the gun.
-- 12/26/2020
-- Minhnormal

local RunService = game:GetService("RunService")

local RecoilService = {}
RecoilService.__index = RecoilService

function RecoilService.new()
    local self = {}

    self.recoilPattern = {
        {3, 12, -1, 0.77, -0.1},
        {6, 12, -1, 0.77, 0.1},
        {8, 12, -1, 0.77, -0.1},
        {10, 12, -1, 0.77, 0.1},
        
    }

    self.recoilReset = 0.1 -- Time it takes for recoil to reset back to 1
    self.currentShots = 0
    self.lastClick = tick()

    setmetatable(self, RecoilService)
    return self
end


function lerp(a, b, t)
    return a * (1-t) + (b*t)
end


function RecoilService:applyRecoil()
    self.currentShots = (tick()-self.lastClick > self.recoilReset and 1 or self.currentShots + 1)
    self.lastClick = tick()

    for _, recoil in pairs(self.recoilPattern) do
        if self.currentShots <= recoil[1] then -- Found the current recoil we're at.
            spawn(function ()
                local number = 0
                while math.abs(number-recoil[2]) > 0.01 do
                    number = lerp(number, recoil[2], recoil[4])
                    local recoilApply = number / 10
                    workspace.CurrentCamera.CFrame *= CFrame.Angles(math.rad(recoilApply), math.rad(recoilApply*recoil[5]), 0)
                    RunService.RenderStepped:Wait()
                end
            end)
            break
        end
    end
end

return RecoilService