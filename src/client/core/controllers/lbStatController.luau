local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local leaderboardUi = require(ReplicatedStorage.client.reactComponents.leaderboardUi)
local zap = require(ReplicatedStorage.zap)
local leaderboardStatController = {}

local function app(props)
	return React.createElement(leaderboardUi, props)
end

local statToLb = {}

local function initializeLeaderboard(leaderboard)
	print("Got here")
	-- Create the UI root for the leaderboard
	local root = ReactRoblox.createRoot(leaderboard)
	local trackingStat = leaderboard:GetAttribute("TrackingStat")
	statToLb[trackingStat] = root

	-- Get initial leaderboard data
	local lbData = zap.getLbData.Call(trackingStat)
	root:render(app({ lbData = lbData, trackingStat = trackingStat }))
end

function leaderboardStatController.start()
	-- Initialize already loaded leaderboards
	for _, leaderboard in CollectionService:GetTagged("Leaderboard") do
		initializeLeaderboard(leaderboard)
	end

	-- Listen for dynamically loaded leaderboards
	CollectionService:GetInstanceAddedSignal("Leaderboard"):Connect(initializeLeaderboard)

	-- Set callback for updating leaderboard data
	zap.updateLbData.SetCallback(function(data)
		local root = statToLb[data.trackingStat]
		if not root then
			-- Leaderboard instance may not be loaded into memory yet
			return
		end

		root:render(app({ lbData = data.lbData, trackingStat = data.trackingStat }))
	end)
end

return leaderboardStatController
