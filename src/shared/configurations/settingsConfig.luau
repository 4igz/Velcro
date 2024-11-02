local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local weaponConfig = require(script.Parent.weaponConfig)
local zap = RunService:IsClient() and require(ReplicatedStorage.zap)

return {
	General = {
		["OTS Camera Sensitivity"] = {
			min = 0.5,
			max = 10,
			step = 0.1,
			default = 3,
			order = 0,
			stepFunction = function(value: number)
				weaponConfig.signals.setSensitivity:Fire(value)
			end,
		},
		["OTS Aim Sensitivity"] = {
			min = 0.1,
			max = 5,
			step = 0.1,
			default = 1.5,
			order = 1,
			stepFunction = function(value: number)
				weaponConfig.signals.setAimSensitivity:Fire(value)
			end,
		},
		FOV = {
			min = 70,
			max = 120,
			step = 1,
			default = 90,
			order = 2,
			stepFunction = function(value: number)
				weaponConfig.signals.setFov:Fire(value)
			end,
		},
		["Camera Shake"] = {
			default = true,
			order = 3,
			stepFunction = function(value: number)
				weaponConfig.signals.toggleCameraShake:Fire(value)
			end,
		},
		["Damage Numbers"] = {
			default = true,
			order = 4,
			stepFunction = function(value: boolean)
				weaponConfig.signals.toggleDamageNumbers:Fire(value)
			end,
		},
	},
	Graphics = {
		["Disable Others Rays"] = {
			default = false,
			stepFunction = function(value: boolean)
				weaponConfig.signals.toggleOthersRays:Fire(value)
			end,
		},
		["Disable Zombie VFX"] = {
			default = false,
			stepFunction = function(value: boolean)
				sharedInfo.UISignals.toggleZombieVFX:Fire(value)
			end,
		},
		["Performance Mode"] = {
			default = false,
			stepFunction = function(isEnabled: boolean)
				Lighting.GlobalShadows = not isEnabled
				Lighting.SunRays.Enabled = not isEnabled
				-- TODO: Other optimizations
			end,
		},
	},
	Sound = {
		["Weapon Volume"] = {
			min = 0,
			max = 1,
			step = 0.1,
			default = 1,
			stepFunction = function(value: number)
				SoundService.Weapons.Volume = value
			end,
		},
		["UI Volume"] = {
			min = 0,
			max = 1,
			step = 0.1,
			default = 1,
			stepFunction = function(value: number)
				SoundService.UI.Volume = value
			end,
		},
	},
	Other = {
		AFK = {
			default = false,
			stepFunction = function(value: boolean)
				zap.toggleAFKMode.Fire(value)
			end,
		},
	},
}
