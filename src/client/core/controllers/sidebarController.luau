local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local energyDisplay = require(ReplicatedStorage.client.reactComponents.energyDisplay)
local hudUi = require(ReplicatedStorage.client.reactComponents.sidebar)
local zap = require(ReplicatedStorage.zap)

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.Name = "HUD"

local hudUiController = {}

function hudUiController.start()
	hudUi(gui)
end

return hudUiController
