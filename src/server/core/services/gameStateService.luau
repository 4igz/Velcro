local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local playerStateService = require(script.Parent.playerStateService)
local zap = require(ServerStorage.zap)
local gameStateService = {}

local START_ROUND_TIME = 120 -- Total time for each round (e.g., 120 seconds)

local currentRound = 11
local roundActive = false
local roundTime = 0 -- Time left in the current round
local loadedMap = nil

local mapFolder = ServerStorage.Maps
local workspaceMapContent = workspace.MapContainer.MapContent

gameStateService.startingRound = Signal.new()
gameStateService.endingGame = Signal.new()

-- Initialize or reset the round time
function gameStateService.resetRoundTime()
	roundTime = START_ROUND_TIME
end

-- Reduce the round time and check for timeout
function gameStateService.reduceRoundTime(deltaTime)
	if roundActive then
		roundTime -= deltaTime

		if roundTime <= 0 then
			gameStateService.endGame()
			print("Round ended due to timeout. Game Over!")
			return true -- Indicate that the round has ended due to time running out
		end
	end
	return false
end

function gameStateService.getCurrentRound()
	return currentRound
end

function gameStateService.loadMap(mapName: string)
	local map = mapFolder:FindFirstChild(mapName)
	if not map then
		error(`No map named {mapName} could be found.`, 2)
	end

	-- Set old map back to the mapFolder if it still exists
	if loadedMap then
		loadedMap.Parent = mapFolder
	end

	-- Set new map to the workspace
	loadedMap = map
	map.Parent = workspaceMapContent
end

function gameStateService.advanceRound()
	currentRound += 1
end

function gameStateService.isRoundActive()
	return roundActive
end

function gameStateService.endGame()
	gameStateService.endingGame:Fire(currentRound)
	roundActive = false
	loadedMap.Parent = mapFolder
	currentRound = 0
	loadedMap = nil

	-- Respawn all players
	for _, player in Players:GetPlayers() do
		player:LoadCharacter()
	end

	zap.updateUI.FireAll({ gameActive = false })
end

function gameStateService.startNewRound(mapName: string)
	gameStateService.resetRoundTime()
	gameStateService.advanceRound()
	roundActive = true
	gameStateService.startingRound:Fire(currentRound)

	if not loadedMap then
		gameStateService.loadMap(mapName)

		task.wait(1) -- wait for some time for map to load

		for _, player in Players:GetPlayers() do
			if playerStateService.getPlayerState(player).playing then
				task.spawn(function()
					local character = player.Character or player.CharacterAdded:Wait()
					character:PivotTo(loadedMap.SpawnLocation.CFrame)
					playerStateService.updatePlayerState(player, { inMap = true })
				end)
			end
		end
	end
end

function gameStateService.getTimeLeft()
	return roundTime
end

function gameStateService.start()
	-- gameStateService.startNewRound()
end

return gameStateService
