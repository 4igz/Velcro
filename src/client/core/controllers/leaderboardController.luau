local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local leaderboardUi = require(ReplicatedStorage.client.reactComponents.leaderboard)
local topBarController = {}

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false
gui.Name = "Leaderboard"

local function app()
	return React.createElement(leaderboardUi, {})
end

function topBarController.start()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

	ReactRoblox.createRoot(Instance.new("Folder")):render(ReactRoblox.createPortal(app(), gui))
end

return topBarController
