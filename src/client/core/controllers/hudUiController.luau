local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local hudUi = require(ReplicatedStorage.client.reactComponents.hudUi)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false
gui.Name = "HUD"

local hudUiController = {}

function hudUiController.setVisibility(value)
	gui.Enabled = value
end

function hudUiController.start()
	task.spawn(function()
		-- Cache all gamepasses so gamepass ui opens immediately.
		for _, id in sharedInfo.Gamepasses do
			MarketplaceService:UserOwnsGamePassAsync(Players.LocalPlayer.UserId, id)
		end
	end)
	sharedInfo.UISignals.deployed:Once(function()
		hudUi(gui)
	end)
end

return hudUiController
