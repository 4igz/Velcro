local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local hudUi = require(ReplicatedStorage.client.reactComponents.hudUi)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.Name = "HUD"

local hudUiController = {}

function hudUiController.start()
	task.spawn(function()
		-- Cache all gamepasses so gamepass ui opens immediately.
		for _, id in sharedInfo.Gamepasses do
			MarketplaceService:UserOwnsGamePassAsync(Players.LocalPlayer.UserId, id)
		end
	end)
	hudUi(gui)
end

return hudUiController
