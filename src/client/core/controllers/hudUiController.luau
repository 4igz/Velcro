local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local gamepassShop = require(ReplicatedStorage.client.reactComponents.gamepassShop)
local hudUi = require(ReplicatedStorage.client.reactComponents.hudUi)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false
gui.Name = "HUD"

local gui2 = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui2.ResetOnSpawn = false
gui2.Name = "GamepassHUD"
local root = ReactRoblox.createRoot(gui2)

local hudUiController = {}

function hudUiController.setVisibility(value)
	gui.Enabled = value
end

local function openGamepassShop(val)
	root:render(gamepassShop({
		visible = val,
		onClose = function()
			openGamepassShop(false)
		end,
	}))
end

function hudUiController.start()
	task.spawn(function()
		-- Cache all gamepasses so gamepass ui opens immediately.
		for _, id in sharedInfo.Gamepasses do
			MarketplaceService:UserOwnsGamePassAsync(Players.LocalPlayer.UserId, id)
		end
	end)
	sharedInfo.UISignals.deployed:Once(function()
		hudUi({ gui = gui, openGamepassShop = openGamepassShop })
	end)
end

return hudUiController
