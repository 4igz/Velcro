local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local zap = require(ServerStorage.zap)
local gameStateService = {}

local MAP_IMAGES = {
	Dust = "rbxassetid://80196594037659",
	Grasslands = "rbxassetid://136327362137218",
	Spaceship = "rbxassetid://109905657060517",
	Harbor = "rbxassetid://134415720948116",
	Depot = "rbxassetid://72699928748098",
	Bricktops = "rbxassetid://111608068909443",
	Pitlord = "rbxassetid://115671548050760",
}

local START_ROUND_TIME = 120 -- Total time for each round (e.g., 120 seconds)
local INTERMISSION_TIME = 15 -- Time for the intermission phase (e.g., 30 seconds)

local currentRound = 30
local roundActive = false
local intermissionActive = true
local roundTime = 0 -- Time left in the current round
local intermissionTime = 0 -- Time left in the intermission
local loadedMap = nil

local mapFolder = ServerStorage.Maps
local workspaceMapContent = workspace.MapContainer.MapContent

local mapVotes = {} -- Table to track map votes
local playerVotes = {} -- Track which map each player has voted for
local playersInMap = {}

local availableMaps = mapFolder:GetChildren()

gameStateService.startingRound = Signal.new()
gameStateService.endingGame = Signal.new()
gameStateService.startingIntermission = Signal.new()
gameStateService.endingIntermission = Signal.new()

-- Initialize or reset the round time
function gameStateService.resetRoundTime()
	local zombies = (5 + 6 * (currentRound - 1)) * (1 + math.log(#Players:GetPlayers()))
	roundTime = (zombies * 2) + START_ROUND_TIME
end

-- Initialize or reset the intermission time
function gameStateService.resetIntermissionTime()
	intermissionTime = INTERMISSION_TIME
end
function gameStateService.reduceRoundTime(deltaTime)
	if roundActive then
		roundTime -= deltaTime

		if roundTime <= 0 and roundActive then
			-- End the game and transition into intermission
			print("Round ended due to timeout. Game Over!")
			gameStateService.endGame() -- This will end the game and automatically start the intermission
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
			return true -- Indicate that the intermission has ended
		end
	end
	return false
end

function gameStateService.getCurrentRound()
	return currentRound
end

function gameStateService.loadMap(mapName: string)
	if type(mapName) ~= "string" then
		mapName = mapName.Name
	end
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

	-- Fisher-Yates shuffle
	for i = #maps, 2, -1 do
		local j = math.random(1, i)
		maps[i], maps[j] = maps[j], maps[i]
	end

	-- Only return the first `numberOfMaps` elements
	local selectedMaps = {}
	for i = 1, math.min(numberOfMaps, #maps) do
		table.insert(selectedMaps, maps[i].Name) -- Access the Instance's Name field
	end

	return selectedMaps
end

-- Start the intermission phase
function gameStateService.startIntermission()
	gameStateService.resetIntermissionTime()
	intermissionActive = true
	table.clear(mapVotes) -- Reset map votes
	gameStateService.startingIntermission:Fire()

	-- Select 5 random map names from allMaps
	availableMaps = getRandomMaps(mapFolder:GetChildren(), 4)

	-- Notify all players about the available maps and allow them to vote
	zap.updateUI.FireAll({
		timeLeft = INTERMISSION_TIME,
		wave = 0,
		wavesTillBoss = 0,
		zombies = 0,
		gameActive = true,
	})

	-- Update voting boards
	for i, votingUi in CollectionService:GetTagged("VotingBoard") do
		local selectedMap = availableMaps[i]
		votingUi:SetAttribute("map", selectedMap)

		local bg = votingUi.BG
		bg.MapName.Text = `{string.upper(selectedMap)} - {mapVotes[selectedMap] or 0}`
		bg.BG.Image = MAP_IMAGES[selectedMap]
	end
end

function gameStateService.getIntermissionActive()
	return intermissionActive
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

	-- Check if the player has already voted for a map
	local previousVote = playerVotes[player.UserId]

	-- If the player has voted before, remove the old vote
	if previousVote then
		mapVotes[previousVote] = mapVotes[previousVote] - 1
		-- Ensure vote count doesn't go negative
		if mapVotes[previousVote] < 0 then
			mapVotes[previousVote] = 0
		end
	end

	-- Record the new vote
	playerVotes[player.UserId] = mapName
	mapVotes[mapName] = (mapVotes[mapName] or 0) + 1

	-- Update voting boards
	for i, votingUi in CollectionService:GetTagged("VotingBoard") do
		local name = votingUi:GetAttribute("map")

		local bg = votingUi.BG
		bg.MapName.Text = `{string.upper(name)} - {mapVotes[name] or 0}`
	end
end

-- Get the map with the most votes
function gameStateService.getMapWithMostVotes()
	local highestVotes = 0
	local selectedMap = availableMaps[1] -- Default to the first map if no votes
	table.clear(playerVotes)

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
		loadedMap.Parent = mapFolder -- Unload the map
	end

	currentRound = 0
	loadedMap = nil

	-- Respawn all players
	for _, player in Players:GetPlayers() do
		player:LoadCharacter() -- Respawn the character
	end

	table.clear(playersInMap)

	-- Start intermission after the round ends
	gameStateService.startIntermission() -- Ensure the intermission starts properly
end

function gameStateService.startNewRound(mapName: string)
	gameStateService.resetRoundTime()
	gameStateService.advanceRound()
	roundActive = true

	if not loadedMap then
		gameStateService.loadMap(mapName)
		task.wait(1) -- wait for some time for map to load
	end

	gameStateService.startingRound:Fire(currentRound)

	-- Define the area around the SpawnLocation where players can randomly spawn
	local spawnLocation = loadedMap.SpawnLocation
	for _, player in Players:GetPlayers() do
		if not table.find(playersInMap, player) then
			task.spawn(function()
				player:RequestStreamAroundAsync(spawnLocation.Position)
				-- Move the player to the new randomized spawn location
				-- character:PivotTo(randomSpawnPosition)
				-- We do this in order to make sure the client knows when to tp because the floor will have been streamed
				zap.tpToMap.Fire(player, loadedMap.Name)
				table.insert(playersInMap, player)
			end)
		end
	end
end

function gameStateService.mapLoaded()
	return loadedMap
end

function gameStateService.getTimeLeft()
	return roundTime
end

function gameStateService.getIntermissionTime()
	return intermissionTime
end

function gameStateService.start()
	gameStateService.startIntermission()

	zap.voteForMap.SetCallback(function(player, mapName)
		if intermissionActive then
			gameStateService.voteForMap(player, mapName)
		end
	end)

	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			local humanoid = character:WaitForChild("Humanoid")
			humanoid.Died:Connect(function()
				if not roundActive then
					return
				end

				local playerInMap = table.find(playersInMap, player)

				if playerInMap then
					table.remove(playersInMap, playerInMap)
				end

				-- Check if any players are still in the map
				-- If no players are in the map, end the game and start intermission
				if #playersInMap == 0 then
					print("All players are dead. Ending game and starting intermission.")
					gameStateService.endGame()
				end
			end)
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		if table.find(playersInMap, player) then
			table.remove(playersInMap, table.find(playersInMap, player))
		end

		-- Check if any players are still in the map
		-- If no players are in the map, end the game and start intermission
		if #playersInMap == 0 then
			print("All players are dead. Ending game and starting intermission.")
			gameStateService.endGame()
		end
	end)
end

return gameStateService
