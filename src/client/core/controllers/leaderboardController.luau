local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local leaderboardUi = require(ReplicatedStorage.client.reactComponents.leaderboard)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local leaderboardController = {}

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false
gui.Name = "Leaderboard"

local function app()
	return React.createElement(leaderboardUi, {})
end

function leaderboardController.setVisibility(value)
	gui.Enabled = value
end

function leaderboardController.start() end

return leaderboardController
