wait(6)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local clientModules = game.Players.LocalPlayer.PlayerScripts.ClientModules

local ClientWeaponService = require(clientModules.FpsModules.ClientWeaponService).new(ReplicatedStorage.Weapons, ReplicatedStorage.Objects.Viewmodel)

ClientWeaponService:bindEquipViewmodelWeapons()