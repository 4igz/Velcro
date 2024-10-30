local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sharedPackages = ReplicatedStorage.sharedPackages

local Promise = require(sharedPackages.Promise)
local Sift = require(ReplicatedStorage.sharedPackages.Sift)
local Signal = require(sharedPackages.Signal)
local playerDataService = require(script.Parent.playerDataService)

local RETRY_GET_STATE_TIMES = 10
local RETRY_DELAY = 0.1

local playerStateService = {}

playerStateService.stateChange = Signal.new()

local playerStates = {}

function playerStateService.start()
	Players.PlayerAdded:Connect(function(player)
		playerStates[player] = {
			Life = { -- Resets on Respawn
				isZombie = false,
			},
			exampleState = false,
			Leaderboard = {
				Level = 0,
				Money = 0,
			},
			playing = true,
			inMap = false,
		}
		local leaderstats = player:FindFirstChild("leaderstats")
		if not leaderstats then
			-- Create the leaderstats folder if it doesn't exist
			leaderstats = Instance.new("Folder")
			leaderstats.Name = "leaderstats"
			leaderstats.Parent = player
		end

		-- Initialize for now
		playerStateService.updateLeaderstats(player, playerStates[player].Leaderboard)

		local profile = playerDataService.getProfile(player)

		playerStateService.updateLeaderstats(player, profile.Data)

		player.CharacterAdded:Connect(function(_character)
			playerStates[player].Life = {
				isZombie = false,
			}
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		if playerStates[player] then
			playerStates[player] = nil
		end
	end)

	playerDataService.playerDataChanged:Connect(function(player, newProfile)
		if newProfile then
			playerStateService.updateLeaderstats(player, newProfile.Data)
		end
	end)
end

function playerStateService.updateLeaderstats(player, profileData)
	if not profileData then
		return
	end
	-- Check if leaderstats folder already exists
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		-- Create the leaderstats folder if it doesn't exist
		leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	-- Define which stats should be shown on the leaderboard
	local leaderboardFields = {}

	local playerState = playerStateService.getPlayerState(player)

	for fieldName, value in playerState.Leaderboard do
		leaderboardFields[fieldName] = profileData[fieldName]
	end

	-- Update each stat in the leaderboard data
	for statName, value in leaderboardFields do
		local stat = leaderstats:FindFirstChild(statName)
		if not stat then
			-- If the stat doesn't exist, create it
			stat = Instance.new("IntValue")
			stat.Name = statName
			stat.Parent = leaderstats
		end
		-- Update the value of the stat
		stat.Value = value
	end
end

-- Preferably used inside of PlayerAdded events
function playerStateService.waitForPlayerState(player: Player): {}?
	local promise = Promise.retryWithDelay(function()
		return Promise.new(function(resolve, reject)
			local state = playerStates[player]
			if state then
				resolve(state)
			else
				reject(state)
			end
		end)
	end, RETRY_GET_STATE_TIMES, RETRY_DELAY)

	local success, state = promise:await()

	if not success then
		return
	end

	return state
end

function playerStateService.setPlayerState(player: Player, newState)
	playerStates[player] = newState
	playerStateService.stateChange:Fire(player, newState)
end

function playerStateService.updatePlayerState(player: Player, updatedState)
	playerStateService.setPlayerState(
		player,
		Sift.Dictionary.merge(updatedState, playerStateService.getPlayerState(player))
	)
end

function playerStateService.getPlayerState(player: Player)
	return playerStates[player]
end

return playerStateService
