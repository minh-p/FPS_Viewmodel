local ReplicatedStorage = game:GetService("ReplicatedStorage")

local clientModules = game.Players.LocalPlayer.PlayerScripts.ClientModules

local ClientWeaponService = require(clientModules.FpsModules.ClientWeaponService).new(ReplicatedStorage:WaitForChild("Weapons"), ReplicatedStorage:WaitForChild("Objects").Viewmodel)

ClientWeaponService:bindEquipViewmodelWeapons()