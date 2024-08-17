local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local zap = require(ServerStorage.zap)
local gameStateService = {}

local START_ROUND_TIME = 120 -- Total time for each round (e.g., 120 seconds)

local currentRound = 0
local roundActive = false
local roundTime = 0 -- Time left in the current round

gameStateService.startingRound = Signal.new()

-- Initialize or reset the round time
function gameStateService.resetRoundTime()
	roundTime = START_ROUND_TIME
end

-- Reduce the round time and check for timeout
function gameStateService.reduceRoundTime(deltaTime)
	if roundActive then
		roundTime -= deltaTime

		-- Check if a whole second has passed and print the message
		if math.floor(roundTime + deltaTime) > math.floor(roundTime) then
			zap.updateUI.FireAll({
				wave = currentRound,
				timeLeft = math.floor(roundTime),
				gameActive = roundActive,
			})
		end

		if roundTime <= 0 then
			gameStateService.endRound()
			print("Round ended due to timeout. Game Over!")
			return true -- Indicate that the round has ended due to time running out
		end
	end
	return false
end

function gameStateService.getCurrentRound()
	return currentRound
end

function gameStateService.advanceRound()
	currentRound += 1
end

function gameStateService.isRoundActive()
	return roundActive
end

function gameStateService.endRound()
	roundActive = false
	zap.updateUI.FireAll({ gameActive = false })
end

function gameStateService.startNewRound()
	gameStateService.resetRoundTime()
	gameStateService.advanceRound()
	roundActive = true
	gameStateService.startingRound:Fire(currentRound)
end

function gameStateService.getTimeLeft()
	return roundTime
end

function gameStateService.start()
	-- gameStateService.startNewRound()
end

return gameStateService
