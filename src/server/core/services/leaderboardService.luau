local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local playerDataService = require(ServerStorage.server.services.playerDataService)
local playerStateService = require(script.Parent.playerStateService)

local leaderboardService = { client = {} }

local function makeLeaderstatValue(value: string | number | boolean)
	local tv = {
		number = "NumberValue",
		string = "StringValue",
	}

	for type, valueType in tv do
		if typeof(value) == type then
			return Instance.new(valueType)
		end
	end
end

local function playerAdded(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	task.spawn(function()
		local profile = playerDataService.getProfile(player)
		local state = playerStateService.waitForPlayerState(player)
		if state then
			for name, value in state.Leaderboard do
				local instanceValue = makeLeaderstatValue(value)
				instanceValue.Name = name
				if profile.Data[name] then
					instanceValue.Value = profile.Data[name]
				end
				instanceValue.Parent = leaderstats
			end
		end
	end)

	local character = player.Character or player.CharacterAdded:Wait()
end

local function getState(player: Player, name: string)
	if not player:IsDescendantOf(Players) then
		return
	end
	local state = playerStateService.getPlayerState(player)
	assert(
		state ~= nil and state.Leaderboard[name] ~= nil,
		`{name} is not a stat in {state.Leaderboard}`
	)
	return state
end

function leaderboardService.increment(player: Player, statName: string, value: number)
	local state = getState(player, statName)
	state.Leaderboard[statName] += value
	player.leaderstats[statName].Value += value
	playerStateService.setPlayerState(player, state)
end

function leaderboardService.setStat(player: Player, statName: string, value: any)
	local state = getState(player, statName)
	state.Leaderboard[statName] = value
	player.leaderstats[statName].Value = value
	playerStateService.setPlayerState(player, state)
end

function leaderboardService.start()
	Players.PlayerAdded:Connect(playerAdded)

	for _, player: Player in Players:GetPlayers() do
		task.spawn(playerAdded, player)
	end

	playerDataService.playerDataChanged:Connect(function(player, newProfile)
		local state = playerStateService.getPlayerState(player)
		local leaderstats = player.leaderstats
		for k, v in newProfile.Data do
			if not state.Leaderboard[k] then
				continue
			end
			state.Leaderboard[k] = newProfile.Data[k]
			leaderstats:FindFirstChild(k).Value = v
		end
		playerStateService.setPlayerState(player, state)
	end)
end

return leaderboardService
