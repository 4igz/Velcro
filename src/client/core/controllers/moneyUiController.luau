local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local gainUi = require(ReplicatedStorage.client.reactComponents.moneyUi)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local moneyUIController = {}

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false
gui.Name = "MoneyUI"

local function app()
	return React.createElement(gainUi)
end

function moneyUIController.setVisibility(value)
	gui.Enabled = value
end

function moneyUIController.start()
	if true then
		return
	end
	local root = ReactRoblox.createRoot(Instance.new("Folder"))

	sharedInfo.UISignals.deployed:Once(function()
		root:render(ReactRoblox.createPortal(app(), gui))
	end)
end

return moneyUIController
