local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")

local Sift = require(ReplicatedStorage.sharedPackages.Sift)
local fogCycle = require(script.Parent.fogCycleService)
local gameStateService = require(script.Parent.gameStateService)
local zap = require(ServerStorage.zap)
local zombieConfigModule = require(ReplicatedStorage.shared.configurations.zombieConfig)
local zombieUtil = require(ReplicatedStorage.shared.utilities.zombieUtil)
local zombieConfig, zombieAi, signals =
	zombieConfigModule[1], zombieConfigModule[2], zombieConfigModule[3]
local zombieService = {}
local zombieContainer = workspace.Zombies

local MAX_ZOMBIES_SPAWNED_AT_ONCE = 30

local zombieFolder = ServerStorage.ZombieTypes
local defaultZombieConfig = zombieConfig.Zombie

-- Table to keep track of all zombie components
local zombieComponents = {}
local queuedZombies = {}

local zombieDeathTween = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Function to apply highlight to a zombie
local function applyHighlightToZombie(zombieModel)
	-- Check if the highlight instance already exists
	if not zombieModel:FindFirstChild("Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.Parent = zombieModel
	end
end

-- Function to remove highlight from a zombie
local function removeHighlightFromZombie(zombieModel)
	local highlight = zombieModel:FindFirstChild("Highlight")
	if highlight then
		highlight:Destroy()
	end
end

local function clearAllHighlights()
	for _, zombie in pairs(zombieComponents) do
		removeHighlightFromZombie(zombie.model)
	end
end

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

	assert(gameStateService.mapLoaded(), "Map was not loaded and we're trying to spawn a zombie!")

	-- Implement the logic to spawn the actual zombie model in the game world
	local zombieModel = zombieFolder:FindFirstChild(type)
	if not zombieModel then
		warn(`No zombieType {type} found in zombie folder`)
		return
	end
	zombieModel = zombieModel:Clone()
	zombieModel.PrimaryPart = zombieModel:FindFirstChild("HumanoidRootPart")
	zombieModel:PivotTo(cframe)
	zombieModel.Parent = zombieContainer
	zombie.model = zombieModel
	zombie.allZombies = zombieComponents
	CollectionService:AddTag(zombieModel, "Zombie")
	-- Insert the new zombie into the zombieComponents table
	table.insert(zombieComponents, zombie)
	local i = table.find(zombieComponents, zombie)

	local humanoid: Humanoid = zombieModel.Humanoid

	-- zombie health increases per wave
	humanoid.MaxHealth =
		math.min(1000, cfg.health * (1 + (0.03 * gameStateService.getCurrentRound())))
	humanoid.Health = humanoid.MaxHealth

	humanoid.WalkSpeed = cfg.speed
	local ai = zombieAi[cfg.aiType or "basic"]
	if ai and ai.chase then
		task.spawn(function()
			ai.chase(zombie, i)
		end)
		zombie.aiRunning = true
	end

	humanoid.Died:Connect(function()
		zombieUtil.createRagdoll(zombieModel)
		-- Create an impulse that pushes the zombie backwards
		local index = table.find(zombieComponents, zombie)
		if index then
			table.remove(zombieComponents, index)
		end
		if not gameStateService.isRoundActive() then
			return -- Only remove zombies if the round is active
		end
		-- Tween and clean up after zombie death
		for _, des in zombieModel:GetDescendants() do
			if des:IsA("ParticleEmitter") then
				des.Rate = 0
				des.Enabled = false
			end
			if des:IsA("BasePart") then
				TweenService:Create(des, zombieDeathTween, { Transparency = 1 }):Play()
			end
		end
		task.delay(2, function()
			zombieModel:Destroy()
		end)

		-- Highlight the last 4 zombies
		if #zombieComponents <= 4 then
			for _, z in pairs(zombieComponents) do
				applyHighlightToZombie(z.model)
			end
		end

		-- Update UI
		zap.updateUI.FireAll({
			zombies = #zombieComponents + #queuedZombies,
			gameActive = gameStateService.isRoundActive(),
			timeLeft = gameStateService.getTimeLeft(),
		})
		signals.zombieDied:Fire(zombie)
	end)
end

function zombieService.getActiveZombies()
	return zombieComponents
end

function zombieService.getNumZombies()
	return #zombieComponents
end

local hasSpawnedElite = false
local spawnedElites = {} -- Track spawned elite zombies per round

--[[
    @param roundNum The current round number, determining which zombie types are eligible and how many zombies to spawn.

    Spawns a specified number of zombies based on the current game round, with a preference for zombies
    that have been eligible to spawn for more rounds (thus making it more likely to spawn zombies from
    higher rounds as the game progresses).
--]]
function zombieService.spawnZombies(roundNum)
	local numPlayers = #Players:GetPlayers()
	local numZombiesToSpawn = (5 + 6 * (roundNum - 1)) * (1 + math.log(numPlayers))
	local possibleTypes = {}
	local eliteTypes = {}
	local totalWeight = 0

	-- Collect eligible zombie types and their cumulative weights
	for zombieType, config in zombieConfig do
		if roundNum >= config.beginSpawningRound then
			local wt = totalWeight + (roundNum - config.beginSpawningRound + 1)

			-- Handle elite zombies separately
			if config.type == "elite" then
				table.insert(eliteTypes, {
					type = zombieType,
					cumulativeWeight = wt,
				})
			else
				table.insert(possibleTypes, {
					type = zombieType,
					cumulativeWeight = wt,
				})
			end
			totalWeight = wt
		end
	end

	-- Ensure there's at least the default "Zombie" type
	if #possibleTypes == 0 then
		possibleTypes = { { type = "Zombie", cumulativeWeight = 1 } }
		totalWeight = 1
	end

	-- Find all spawn points from "ZombieSpawns"
	local spawnPoints = CollectionService:GetTagged("ZombieSpawns")
	spawnPoints = Sift.Array.filter(spawnPoints, function(v)
		return v:IsDescendantOf(workspace)
	end)
	if #spawnPoints == 0 then
		warn("No spawn points found for zombies!")
		return
	end

	-- Add all zombies to the queue
	for _ = 1, numZombiesToSpawn do
		local randomWeight = math.random() * totalWeight
		local zombieType = "Zombie" -- Default if no other found

		-- Determine zombie type based on random weight
		for _, pt in possibleTypes do
			if randomWeight <= pt.cumulativeWeight then
				zombieType = pt.type
				break
			end
		end

		-- Check for elite zombies
		for _, eliteType in eliteTypes do
			if
				not spawnedElites[eliteType.type]
				and roundNum >= zombieConfig[eliteType.type].beginSpawningRound
			then
				zombieType = eliteType.type
				spawnedElites[eliteType.type] = true -- Mark as spawned
				break
			end
		end

		-- Select a random spawn point and add to queue
		local spawnPoint = spawnPoints[math.random(1, #spawnPoints)].CFrame
		table.insert(queuedZombies, { type = zombieType, spawnPoint = spawnPoint })
	end

	-- Spawn zombies from queue
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
				task.wait(0.25)
			else
				task.wait()
			end
		end
	end)
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
	zombieUtil.createShockwave:Connect(function(hitZombies, radius, shockwaveDamage)
		-- Trigger shockwave, damaging nearby zombies
		for _, hitZombie in hitZombies do
			local nearbyZombies = zombieUtil.getNearbyZombies(
				zombieComponents,
				hitZombie.HumanoidRootPart.Position,
				radius
			)
			for _, nearbyZombie in nearbyZombies do
				local humanoid = nearbyZombie:FindFirstChild("Humanoid")
				if humanoid then
					humanoid:TakeDamage(shockwaveDamage)
				end
			end
		end
	end)

	RunService.Heartbeat:Connect(function(deltaTime)
		if #Players:GetPlayers() == 0 then
			return
		end
		-- If the intermission is active, reduce the intermission time
		if gameStateService.getIntermissionActive() then
			gameStateService.reduceIntermissionTime(deltaTime)
		else
			-- Reduce round time and check for timeout
			local roundEndedDueToTimeout = gameStateService.reduceRoundTime(deltaTime)

			-- If all zombies are eliminated and round is active, proceed to next round or intermission
			if #zombieComponents == 0 and gameStateService.isRoundActive() then
				print("All zombies eliminated. Starting next round...")
				gameStateService.startNewRound("")

				-- If the round ended due to timeout or all players are dead, start the intermission
				if roundEndedDueToTimeout or not gameStateService.isRoundActive() then
					-- Ensure the game is ended properly and intermission starts
					if not gameStateService.getIntermissionActive() then
						-- Start the intermission phase
						print("Round ended due to timeout, starting intermission...")
						gameStateService.startIntermission()
					end
				end
			end
		end
	end)

	gameStateService.startingRound:Connect(function(roundNum)
		hasSpawnedElite = false
		table.clear(spawnedElites)
		clearAllHighlights()
		if roundNum % 10 == 0 then
			-- zombieService.spawnBoss(gameStateService.getCurrentRound())
		end

		table.clear(queuedZombies)
		zombieService.spawnZombies(roundNum)
		zap.updateUI.FireAll({
			timeLeft = gameStateService.getTimeLeft(),
			wave = gameStateService.getCurrentRound(),
			wavesTillBoss = gameStateService.getCurrentRound() % 10,
			zombies = #zombieComponents + #queuedZombies,
			gameActive = true,
		})
	end)

	gameStateService.endingGame:Connect(function()
		zombieService.despawnAll()
	end)

	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Wait()
		zap.updateUI.Fire(player, {
			timeLeft = if gameStateService.isRoundActive()
				then gameStateService.getTimeLeft()
				else gameStateService.getIntermissionTime(),
			wave = gameStateService.getCurrentRound(),
			wavesTillBoss = gameStateService.getCurrentRound() % 10,
			zombies = #zombieComponents + #queuedZombies,
			gameActive = gameStateService.isRoundActive(),
		})
	end)
end

return zombieService
