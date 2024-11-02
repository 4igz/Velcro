local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local gamepassShop = require(ReplicatedStorage.client.reactComponents.gamepassShop)
local hudUi = require(ReplicatedStorage.client.reactComponents.hudUi)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local zap = require(ReplicatedStorage.zap)

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false
gui.Name = "HUD"

local hudUiController = {}

function hudUiController.setVisibility(value)
	gui.Enabled = value
end

function hudUiController.start()
	zap.playSound.SetCallback(function(name)
		SoundService.UI[name]:Play()
	end)

	hudUi({ gui = gui })
end

return hudUiController
