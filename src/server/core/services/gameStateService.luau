local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local playerStateService = require(script.Parent.playerStateService)
local zap = require(ServerStorage.zap)
local gameStateService = {}

local START_ROUND_TIME = 120 -- Total time for each round (e.g., 120 seconds)
local INTERMISSION_TIME = 30 -- Time for the intermission phase (e.g., 30 seconds)

local currentRound = 11
local roundActive = false
local intermissionActive = false
local roundTime = 0 -- Time left in the current round
local intermissionTime = 0 -- Time left in the intermission
local loadedMap = nil

local mapFolder = ServerStorage.Maps
local workspaceMapContent = workspace.MapContainer.MapContent

local mapVotes = {} -- Table to track map votes

gameStateService.startingRound = Signal.new()
gameStateService.endingGame = Signal.new()
gameStateService.startingIntermission = Signal.new()
gameStateService.endingIntermission = Signal.new()

-- Initialize or reset the round time
function gameStateService.resetRoundTime()
	roundTime = START_ROUND_TIME
end

-- Initialize or reset the intermission time
function gameStateService.resetIntermissionTime()
	intermissionTime = INTERMISSION_TIME
end

-- Reduce the round time and check for timeout
function gameStateService.reduceRoundTime(deltaTime)
	if roundActive then
		roundTime -= deltaTime

		if roundTime <= 0 and roundActive then
			gameStateService.endGame()
			print("Round ended due to timeout. Game Over!")
			return true -- Indicate that the round has ended due to time running out
		end
	end
	return false
end

-- Reduce the intermission time and check for timeout
function gameStateService.reduceIntermissionTime(deltaTime)
	if intermissionActive then
		intermissionTime -= deltaTime

		if intermissionTime <= 0 and intermissionActive then
			gameStateService.endIntermission()
			print("Intermission ended. Starting new round!")
			return true -- Indicate that the intermission has ended
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

-- Utility function to get a random selection of n items from a list
local function getRandomMaps(mapList, numberOfMaps): { string }
	local maps = {}
	for _, map in mapList do
		table.insert(maps, map)
	end

	-- Shuffle maps
	table.sort(maps, function()
		return math.random() < 0.5
	end)

	-- Only return the first `numberOfMaps` elements
	local selectedMaps = {}
	for i = 1, math.min(numberOfMaps, #maps) do
		table.insert(selectedMaps, maps[i].Name)
	end

	return selectedMaps
end

-- Start the intermission phase
function gameStateService.startIntermission()
	intermissionActive = true
	gameStateService.resetIntermissionTime()
	mapVotes = {} -- Reset map votes
	gameStateService.startingIntermission:Fire()

	-- Select 5 random map names from allMaps
	availableMaps = getRandomMaps(mapFolder:GetChildren(), 5)

	-- Notify all players about the available maps and allow them to vote
	zap.showVoteUi.FireAll(availableMaps)
end

-- End the intermission and start a new round
function gameStateService.endIntermission()
	if not intermissionActive then
		return
	end

	intermissionActive = false
	gameStateService.endingIntermission:Fire()

	-- Determine which map has the most votes
	local selectedMap = gameStateService.getMapWithMostVotes()
	gameStateService.startNewRound(selectedMap)
end

-- Players cast their vote for a map
function gameStateService.voteForMap(player, mapName)
	if not table.find(availableMaps, mapName) then
		return -- Invalid map vote
	end

	-- Record player's vote
	mapVotes[mapName] = (mapVotes[mapName] or 0) + 1
end

-- Get the map with the most votes
function gameStateService.getMapWithMostVotes()
	local highestVotes = 0
	local selectedMap = availableMaps[1] -- Default to the first map if no votes

	for mapName, votes in mapVotes do
		if votes > highestVotes then
			highestVotes = votes
			selectedMap = mapName
		end
	end

	return selectedMap
end

function gameStateService.endGame()
	if not roundActive then
		return
	end
	gameStateService.endingGame:Fire(currentRound)
	roundActive = false
	if loadedMap then
		loadedMap.Parent = mapFolder
	end
	currentRound = 0
	loadedMap = nil

	-- Respawn all players
	for _, player in Players:GetPlayers() do
		player:LoadCharacter()
	end

	zap.updateUI.FireAll({ gameActive = false })

	-- Start intermission after the round ends
	gameStateService.startIntermission()
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

					-- TODO: Give some randomness so players dont all spawn on top of each other
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
