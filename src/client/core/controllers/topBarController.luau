local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local topBar = require(ReplicatedStorage.client.reactComponents.topBar)
local zap = require(ReplicatedStorage.zap)
local topBarController = {}

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false
gui.Name = "TopBar"

local function app(props)
	return React.createElement(topBar, props)
end

function topBarController.start()
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(app(), gui))

	zap.updateUI.SetCallback(function(props)
		root:render(ReactRoblox.createPortal(app(props), gui))
	end)
end

return topBarController
