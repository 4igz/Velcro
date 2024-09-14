local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local Sift = require(ReplicatedStorage.sharedPackages.Sift)
local gameStateService = require(script.Parent.gameStateService)
local zap = require(ServerStorage.zap)
local zombieConfigModule = require(ReplicatedStorage.shared.configurations.zombieConfig)
local zombieConfig, zombieAi = zombieConfigModule[1], zombieConfigModule[2]
local zombieService = {}

local MAX_ZOMBIES_SPAWNED_AT_ONCE = 30

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

	-- Implement the logic to spawn the actual zombie model in the game world
	local zombieModel = zombieFolder:FindFirstChild(type)
	if not zombieModel then
		warn(`No zombieType {type} found in zombie folder`)
		return
	end
	zombieModel = zombieModel:Clone()
	zombieModel.PrimaryPart = zombieModel:FindFirstChild("HumanoidRootPart")
	zombieModel:PivotTo(cframe)
	zombieModel.Parent = CollectionService:GetTagged("MapContent")[1] or mapContainer
	zombie.model = zombieModel
	CollectionService:AddTag(zombieModel, "Zombie")
	-- Insert the new zombie into the zombieComponents table
	local i = table.insert(zombieComponents, zombie)

	local humanoid: Humanoid = zombieModel.Humanoid
	humanoid.MaxHealth = cfg.health
	humanoid.Health = cfg.health
	humanoid.WalkSpeed = cfg.speed

	-- Handle zombie death
	humanoid.Died:Connect(function()
		if not gameStateService.isRoundActive() then
			print("Round wasn't active")
			return -- Only remove zombies if the round is active
		end
		table.remove(zombieComponents, i)
		task.delay(2, function()
			zombieModel:Destroy()
		end)
		zap.updateUI.FireAll({
			zombies = #zombieComponents,
			gameActive = gameStateService.isRoundActive(),
			timeLeft = gameStateService.getTimeLeft(),
		})
	end)
end

function zombieService.getNumZombies()
	return #zombieComponents
end

-- Function to update all active zombies
-- Applies each zombie's AI update method
function zombieService.startZombieAIs()
	-- Iterate over all zombies in the components list
	for i, zombie in zombieComponents do
		if zombie.aiRunning then
			continue
		end
		local ai = zombieAi[zombie.aiType or "basic"]
		if ai and ai.chase then
			task.spawn(function()
				ai.chase(zombie, i)
			end)
			zombie.aiRunning = true
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
	local numPlayers = #Players:GetPlayers()
	-- Calculate the number of zombies to spawn for this round
	local numZombiesToSpawn = (5 + 6 * (roundNum - 1)) * (1 + math.log(numPlayers))
	local possibleTypes = {}
	local totalWeight = 0

	-- Collect eligible zombie types and their cumulative weights
	for zombieType, config in zombieConfig do
		if roundNum >= config.beginSpawningRound then
			local wt = totalWeight + (roundNum - config.beginSpawningRound + 1)
			table.insert(possibleTypes, {
				type = zombieType,
				cumulativeWeight = wt,
			})
			totalWeight = wt
		end
	end

	-- Ensure there's always at least the default "Zombie" type
	if #possibleTypes == 0 then
		possibleTypes = { { type = "Zombie", cumulativeWeight = 1 } }
		totalWeight = 1
	end

	-- Find all spawn points from the "ZombieSpawns" collection
	local spawnPoints = CollectionService:GetTagged("ZombieSpawns")
	spawnPoints = Sift.Array.filter(spawnPoints, function(v)
		return v:IsDescendantOf(workspace)
	end)
	if #spawnPoints == 0 then
		warn("No spawn points found for zombies!")
		return
	end

	local queuedZombies = {}

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

		if zombieService.getNumZombies() >= MAX_ZOMBIES_SPAWNED_AT_ONCE then
			-- Add zombies to queue if max limit is reached
			table.insert(queuedZombies, { type = zombieType, spawnPoint = spawnPoint })
		else
			zombieService.newZombie(zombieType, spawnPoint)
		end
	end

	zap.updateUI.FireAll({
		timeLeft = gameStateService.getTimeLeft(),
		wave = gameStateService.getCurrentRound(),
		wavesTillBoss = gameStateService.getCurrentRound() % 10,
		zombies = #zombieComponents + #queuedZombies,
		gameActive = true,
	})

	-- Handle queued zombies if the limit was reached during spawning
	if #queuedZombies > 0 then
		task.spawn(function()
			while #queuedZombies > 0 and gameStateService.isRoundActive() do
				if zombieService.getNumZombies() < MAX_ZOMBIES_SPAWNED_AT_ONCE then
					local nextZombie = table.remove(queuedZombies, 1)
					zombieService.newZombie(nextZombie.type, nextZombie.spawnPoint)

					zap.updateUI.FireAll({
						timeLeft = gameStateService.getTimeLeft(),
						wave = gameStateService.getCurrentRound(),
						wavesTillBoss = gameStateService.getCurrentRound() % 10,
						zombies = #zombieComponents + #queuedZombies,
						gameActive = true,
					})
				end
				-- Introduce a slight delay between spawns to avoid overloading the system
				task.wait()
			end
		end)
	end
end

function zombieService.despawnAll()
	for i, zombie in zombieComponents do
		zombie.model:Destroy()
	end
	table.clear(zombieComponents)
end

function zombieService.spawnBoss()
	local spawnPoints = CollectionService:GetTagged("ZombieSpawns")
	local spawnPoint = spawnPoints[math.random(1, #spawnPoints)].Position
	zombieService.newZombie("BossZombie", spawnPoint)
end

function zombieService.start()
	RunService.Heartbeat:Connect(function(deltaTime)
		-- Reduce round time and check for timeout
		local roundEndedDueToTimeout = gameStateService.reduceRoundTime(deltaTime)

		-- If all zombies are eliminated, start the next round
		if #zombieComponents == 0 and gameStateService.isRoundActive() then
			print("All zombies eliminated. Starting next round...")
			gameStateService.startingRound:Fire(gameStateService.getCurrentRound())
			-- Increment the round and start a new wave of zombies
			return
		end

		-- If there are zombies still alive, update their AI
		if #zombieComponents > 0 then
			zombieService.startZombieAIs()
		else
			-- If there are no zombies and round ended due to timeout or all players are dead
			if roundEndedDueToTimeout or not gameStateService.isRoundActive() then
				-- Ensure the game is ended properly and intermission starts
				if not gameStateService.getIntermissionActive() then
					-- If the round ended, start the intermission
					print("Round has ended, starting intermission...")
					gameStateService.startIntermission()
				else
					-- Reduce the intermission timer
					gameStateService.reduceIntermissionTime(deltaTime)
				end
			end
		end
	end)

	gameStateService.startingRound:Connect(function(roundNum)
		gameStateService.advanceRound()
		gameStateService.resetRoundTime()
		if roundNum % 10 == 0 then
			-- zombieService.spawnBoss(gameStateService.getCurrentRound())
		end

		zombieService.spawnZombies(roundNum)

		zap.updateUI.FireAll({
			timeLeft = gameStateService.getTimeLeft(),
			wave = gameStateService.getCurrentRound(),
			wavesTillBoss = gameStateService.getCurrentRound() % 10,
			zombies = 5 + roundNum * 2,
			gameActive = true,
		})
	end)

	gameStateService.endingGame:Connect(function()
		zombieService.despawnAll()
	end)
end

return zombieService
