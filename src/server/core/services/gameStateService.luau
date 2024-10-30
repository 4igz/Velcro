local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local playerDataService = require(script.Parent.playerDataService)
local zap = require(ServerStorage.zap)
local gameStateService = {}

local MAP_IMAGES = {
	Dust = "rbxassetid://80196594037659",
	Grasslands = "rbxassetid://136327362137218",
	Spaceship = "rbxassetid://109905657060517",
	Harbor = "rbxassetid://134415720948116",
	Depot = "rbxassetid://72699928748098",
	Bricktops = "rbxassetid://111608068909443",
	-- Pitlord = "rbxassetid://115671548050760",
	Streets = "rbxassetid://84765611489539",
}

local START_ROUND_TIME = 120 -- Total time for each round (e.g., 120 seconds)
local INTERMISSION_TIME = 15 -- Time for the intermission phase (e.g., 30 seconds)

local currentRound = ServerStorage:GetAttribute("StartingRound") or 0
local roundActive = false
local intermissionActive = true
local roundTime = 0 -- Time left in the current round
local intermissionTime = 0 -- Time left in the intermission
local loadedMap = nil

local mapFolder = ServerStorage.Maps
local workspaceMapContent = workspace.MapContainer.MapContent

local mapVotes = {} -- Table to track map votes
local playerVotes = {} -- Track which map each player has voted for

local availableMaps = mapFolder:GetChildren()

gameStateService.startingRound = Signal.new()
gameStateService.endingGame = Signal.new()
gameStateService.startingIntermission = Signal.new()
gameStateService.endingIntermission = Signal.new()

local playerStates = {}

-- Define player states
local PLAYER_STATE = {
	inHud = "inHud", -- Player is in the main menu HUD
	inLobby = "inLobby", -- Player has deployed but not in the map
	inMap = "inMap", -- Player is actively in the map
	dead = "dead", -- Player has died in the round
}

local playersInMapCount = 0 -- Track the number of players in the 'inMap' state
local playersInLobbyCount = 0 -- Track the number of players in the 'inLobby' state

local function updatePlayerState(player, newState)
	local currentState = playerStates[player.UserId]

	-- Handle 'inMap' state count
	if currentState == PLAYER_STATE.inMap and newState ~= PLAYER_STATE.inMap then
		playersInMapCount -= 1
	elseif currentState ~= PLAYER_STATE.inMap and newState == PLAYER_STATE.inMap then
		playersInMapCount += 1
	end

	-- Handle 'inLobby' state count
	if currentState == PLAYER_STATE.inLobby and newState ~= PLAYER_STATE.inLobby then
		playersInLobbyCount -= 1
	elseif currentState ~= PLAYER_STATE.inLobby and newState == PLAYER_STATE.inLobby then
		playersInLobbyCount += 1
	end

	playerStates[player.UserId] = newState
end

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
		if playersInLobbyCount > 0 then
			intermissionTime -= deltaTime
		end

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
		gameActive = false,
	})

	-- Update voting boards
	for i, votingUi in CollectionService:GetTagged("VotingBoard") do
		local selectedMap = availableMaps[i]
		votingUi:SetAttribute("map", selectedMap)

		local bg = votingUi.BG
		bg.MapName.Text = `{string.upper(selectedMap)} - {mapVotes[selectedMap] or 0}`
		bg.BG.Image = MAP_IMAGES[selectedMap or "Dust"]
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

	-- Respawn all players and set their new records
	for _, player in Players:GetPlayers() do
		local profile = playerDataService.getProfile(player)
		if not profile or not profile.Data then
			continue
		end

		if currentRound > profile.Data.HighestRound then
			profile.Data.HighestRound = currentRound
		end

		if currentRound > 5 then
			profile.Data.GamesPlayed += 1
		end

		playerDataService.setProfile(player, profile)

		player:LoadCharacter() -- Respawn the character
	end

	currentRound = 0
	loadedMap = nil
	-- Start intermission after the round ends
	gameStateService.startIntermission() -- Ensure the intermission starts properly
end

function gameStateService.startNewRound(mapName: string)
	if not loadedMap then
		gameStateService.loadMap(mapName)
		task.wait(1) -- wait for some time for map to load
	end
	gameStateService.startingRound:Fire(currentRound)

	task.defer(function()
		roundActive = true
		gameStateService.resetRoundTime()
		gameStateService.advanceRound()
		if playersInMapCount == 0 then
			gameStateService.endGame()
			return
		end
	end)
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

	zap.joinCurrentRound.SetCallback(function(player)
		if playerStates[player.UserId] == PLAYER_STATE.inLobby and roundActive then
			local spawnLocation = loadedMap.SpawnLocation
			task.spawn(function()
				player:RequestStreamAroundAsync(spawnLocation.Position)
				-- We do this in order to make sure the client knows when to tp because the floor will have been streamed
				zap.tpToMap.Fire(player, loadedMap.Name)
				updatePlayerState(player, PLAYER_STATE.inMap)
				zap.updateUI.Fire(player, {
					playerState = playerStates[player.UserId], -- Send the player's state
				})
			end)
		end
	end)

	-- When a player joins the game they are shown a main menu and are not technically in the game yet
	-- until they hit the deploy button. Once they do so they are able to join the game and play.
	zap.deployed.SetCallback(function(player)
		if playerStates[player.UserId] == PLAYER_STATE.inHud then
			-- Player has clicked the deploy button, moving them to the lobby
			updatePlayerState(player, PLAYER_STATE.inLobby)

			-- Update their UI or any necessary setup now that they are in the lobby
			zap.updateUI.Fire(player, {
				playerState = playerStates[player.UserId], -- Send the player's state
			})
		end
		if not playerStates[player.UserId] then
			updatePlayerState(player, PLAYER_STATE.inLobby)
			zap.updateUI.Fire(player, {
				playerState = playerStates[player.UserId], -- Send the player's state
			})
		end
	end)

	-- When a round starts, move players from lobby to map
	gameStateService.startingRound:Connect(function()
		local spawnLocation = loadedMap.SpawnLocation
		for _, player in Players:GetPlayers() do
			if
				playerStates[player.UserId] == PLAYER_STATE.inLobby
				or playerStates[player.UserId] == PLAYER_STATE.dead
			then
				task.spawn(function()
					local character = player.Character
					local humanoid = character and character:FindFirstChild("Humanoid")
					if not humanoid then
						return
					end
					if humanoid:GetState() == Enum.HumanoidStateType.Dead then
						return
					end
					updatePlayerState(player, PLAYER_STATE.inMap)
					player:RequestStreamAroundAsync(spawnLocation.Position)
					-- We do this in order to make sure the client knows when to tp because the floor will have been streamed
					zap.tpToMap.Fire(player, loadedMap.Name)

					zap.updateUI.Fire(player, {
						playerState = playerStates[player.UserId], -- Send the player's state
					})
				end)
			end
		end
	end)

	gameStateService.endingGame:Connect(function()
		for _, player in Players:GetPlayers() do
			if
				playerStates[player.UserId] == PLAYER_STATE.inMap
				or playerStates[player.UserId] == PLAYER_STATE.dead
			then
				updatePlayerState(player, PLAYER_STATE.inLobby)
			end
		end
	end)

	zap.voteForMap.SetCallback(function(player, mapName)
		if intermissionActive and playerStates[player.UserId] == PLAYER_STATE.inLobby then
			gameStateService.voteForMap(player, mapName)
		end
	end)

	Players.PlayerAdded:Connect(function(player)
		updatePlayerState(player, PLAYER_STATE.inHud)
		zap.updateUI.Fire(player, {
			playerState = playerStates[player.UserId], -- Send the player's state
		})

		player.CharacterAdded:Connect(function(character)
			local humanoid = character:WaitForChild("Humanoid")
			humanoid.Died:Connect(function()
				if playerStates[player.UserId] == PLAYER_STATE.inMap then
					updatePlayerState(player, PLAYER_STATE.dead)

					zap.updateUI.Fire(player, {
						playerState = playerStates[player.UserId], -- Send the player's state
					})

					-- If all players in the map are dead, end the game
					if playersInMapCount == 0 then
						print("All players are dead. Ending game and starting intermission.")
						gameStateService.endGame()
					end
				end
			end)
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		if playerStates[player.UserId] == PLAYER_STATE.inMap then
			playersInMapCount -= 1
		end
		playerStates[player.UserId] = nil

		-- If all players in the map are dead or have left, end the game
		if playersInMapCount == 0 then
			print("All players are dead or have left. Ending game and starting intermission.")
			gameStateService.endGame()
		end
	end)
end

return gameStateService
