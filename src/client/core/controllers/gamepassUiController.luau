local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local gamepassShop = require(ReplicatedStorage.client.reactComponents.gamepassShop)
local gamepassUiController = {}

local gui2 = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui2.ResetOnSpawn = false
gui2.Name = "GamepassHUD"
local root = ReactRoblox.createRoot(gui2)

function gamepassUiController.setGamepassShopOpen(val)
	root:render(gamepassShop({
		visible = val,
		onClose = function()
			gamepassUiController.setGamepassShopOpen(false)
		end,
	}))
end

function gamepassUiController.start()
	task.spawn(function()
		-- Cache all gamepasses so gamepass ui opens immediately.
		root:render(gamepassShop({
			visible = false,
		}))
	end)
end

return gamepassUiController
