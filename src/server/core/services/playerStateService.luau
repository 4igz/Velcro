-- Example service, possibly applicable
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sharedPackages = ReplicatedStorage.sharedPackages

local Promise = require(sharedPackages.Promise)
local Signal = require(sharedPackages.Signal)

local DEFAULT_STATE = {
	Life = { -- Resets on Respawn
		isZombie = false,
	},
	exampleState = false,
}
local RETRY_GET_STATE_TIMES = 10
local RETRY_DELAY = 0.1

local playerStateService = {}

-- :connect(function(player: Player, newState))
playerStateService.stateChange = Signal.new()

local playerStates = {}

function playerStateService.start()
	Players.PlayerAdded:Connect(function(player)
		playerStates[player] = table.clone(DEFAULT_STATE)

		player.CharacterAdded:Connect(function(_character)
			playerStates[player].Life = table.clone(DEFAULT_STATE.Life)
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		if playerStates[player] then
			playerStates[player] = nil
		end
	end)

	playerStateService.stateChange:Connect(function(player, newState)
		-- print(newState.Life)
	end)
end

-- Preferably used inside of PlayerAdded events
function playerStateService.waitForPlayerState(player: Player): table?
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

function playerStateService.getPlayerState(player: Player)
	return table.clone(playerStates[player])
end

return playerStateService
