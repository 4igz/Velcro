local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local gainUi = require(ReplicatedStorage.client.reactComponents.gainUi)
local zap = require(ReplicatedStorage.zap)
local topBarController = {}

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false
gui.Name = "GainUI"

local function newFeed(props)
	return React.createElement(gainUi, props)
end

function topBarController.start()
	local root = ReactRoblox.createRoot(Instance.new("Folder"))

	zap.updateFeeds.SetCallback(function(props)
		root:render(ReactRoblox.createPortal(newFeed(props), gui))
	end)
end

return topBarController
