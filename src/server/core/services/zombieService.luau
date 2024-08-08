local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local gameStateService = require(script.Parent.gameStateService)
local zap = require(ServerStorage.zap)
local zombieConfigModule = require(ReplicatedStorage.shared.configurations.zombieConfig)
local zombieConfig, zombieAi = zombieConfigModule[1], zombieConfigModule[2]
local zombieService = {}

local zombieFolder = ServerStorage.ZombieTypes
local mapContainer = workspace.MapContainer
local defaultZombieConfig = zombieConfig.Zombie

-- Table to keep track of all zombie components
local zombieComponents = {}

--[[
	- @param type: String identifier for the type of zombie to create
	- @param CFrame: CFrame position to spawn the zombie at

	Create a new zombie of a given type at a given position
--]]
function zombieService.newZombie(type, cframe)
	-- Load the configuration for the specified zombie type or throw an error if not found
	local cfg = zombieConfig[type]
		or error(string.format("!! Unknown Zombie Type: '%s' !!", type), 2)

	-- Clone the default zombie configuration
	local zombie = table.clone(defaultZombieConfig)

	-- If the specific configuration is different from the default, override the properties
	if cfg ~= defaultZombieConfig then
		for key, value in pairs(cfg) do
			zombie[key] = value
		end
	end

	-- Insert the new zombie into the zombieComponents table
	table.insert(zombieComponents, zombie)

	-- Implement the logic to spawn the actual zombie model in the game world
	local zombieModel: Model = zombieFolder:FindFirstChild(type):Clone()
	zombieModel:PivotTo(cframe)
	zombieModel.Parent = CollectionService:GetTagged("MapContent")[1] or mapContainer
end

-- Function to update all active zombies
-- Applies each zombie's AI update method
function zombieService.updateZombies()
	-- Iterate over all zombies in the components list
	for i, zombie in zombieComponents do
		local ai = zombie.aiType
		if ai and ai.update then
			ai.update(zombie, i)
		end
	end
end

--[[
    @param roundNum The current round number, determining which zombie types are eligible and how many zombies to spawn.

    Spawns a specified number of zombies based on the current game round, with a preference for zombies
    that have been eligible to spawn for more rounds (thus making it more likely to spawn zombies from
    higher rounds as the game progresses).
--]]
function zombieService.spawnZombies(roundNum)
	-- Calculate the number of zombies to spawn for this round
	local numZombiesToSpawn = 5 + roundNum * 2
	local possibleTypes = {}
	local totalWeight = 0

	-- Collect eligible zombie types and their cumulative weights
	for zombieType, config in zombieConfig do
		if roundNum >= config.beginSpawningRound then
			table.insert(possibleTypes, {
				type = zombieType,
				cumulativeWeight = totalWeight + (roundNum - config.beginSpawningRound + 1),
			})
			totalWeight = totalWeight + (roundNum - config.beginSpawningRound + 1)
		end
	end

	-- Ensure there's always at least the default "Zombie" type
	if #possibleTypes == 0 then
		possibleTypes = { { type = "Zombie", cumulativeWeight = 1 } }
		totalWeight = 1
	end

	-- Find all spawn points from the "ZombieSpawns" collection
	local spawnPoints = CollectionService:GetTagged("ZombieSpawns")
	if #spawnPoints == 0 then
		warn("No spawn points found for zombies!")
		return
	end

	-- Spawn the calculated number of zombies based on the weighted zombie types
	for _ = 1, numZombiesToSpawn do
		local randomWeight = math.random() * totalWeight
		local zombieType = "Zombie" -- Default if no other found

		-- Determine which zombie type to spawn based on the randomWeight
		for _, pt in possibleTypes do
			if randomWeight <= pt.cumulativeWeight then
				zombieType = pt.type
				break
			end
		end

		-- Choose a random spawn point
		local spawnPoint = spawnPoints[math.random(1, #spawnPoints)].CFrame
		zombieService.newZombie(zombieType, spawnPoint)
	end
end

function zombieService.spawnBoss()
	local spawnPoints = CollectionService:GetTagged("ZombieSpawns")
	local spawnPoint = spawnPoints[math.random(1, #spawnPoints)].Position
	zombieService.newZombie("BossZombie", spawnPoint)
end

-- Function to start the main game loop for zombie management
function zombieService.start()
	RunService.Heartbeat:Connect(function(deltaTime)
		if gameStateService.reduceRoundTime(deltaTime) then
			-- If the time runs out, game over logic can be handled here
			return
		end

		if #zombieComponents > 0 then
			zombieService.updateZombies()
		end
	end)

	gameStateService.startingRound:Connect(function(roundNum)
		local currentRound = gameStateService.getCurrentRound()
		if currentRound % 10 == 0 then
			-- zombieService.spawnBoss(gameStateService.getCurrentRound())
		end

		zombieService.spawnZombies(currentRound)
		zap.updateUI.FireAll({
			timeLeft = gameStateService.getTimeLeft(),
			wave = currentRound,
			wavesTillBoss = currentRound % 10,
			zombies = #zombieComponents,
			gameActive = true,
		})
	end)
end

return zombieService
