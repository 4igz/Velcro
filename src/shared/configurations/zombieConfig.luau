local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Sift = require(ReplicatedStorage.sharedPackages.Sift)

local attackCooldown = 2 -- Cooldown time in seconds between attacks
local zombieDebounces = {} -- Table to store the debounce status for each zombie

-- Helper function to find the closest player to the given position
local function findClosestTarget(zombiePosition)
	local closestPlayer = nil
	local minDistance = math.huge

	-- Iterate over all players to find the closest one
	for _, player in Players:GetPlayers() do
		local playerCharacter = player.Character
		if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
			local playerPosition = playerCharacter.HumanoidRootPart.Position
			local distance = (playerPosition - zombiePosition).Magnitude
			if distance < minDistance then
				minDistance = distance
				closestPlayer = player
			end
		end
	end

	return closestPlayer
end

-- Helper function to apply damage
local function applyDamageToPlayer(player, damage)
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid:TakeDamage(damage)
	end
end

-- Helper function for attack debouncing
local function canAttack(zombieId)
	local currentTime = tick()

	-- Initialize debounce table if it doesn't exist
	if not zombieDebounces[zombieId] then
		zombieDebounces[zombieId] = { ["lastAttackTime"] = 0 }
	end

	-- Check cooldown
	if currentTime - zombieDebounces[zombieId].lastAttackTime >= attackCooldown then
		zombieDebounces[zombieId].lastAttackTime = currentTime
		return true
	end

	return false
end

-- Helper function to heal a zombie
local function healZombie(zombie, healAmount)
	local humanoid = zombie:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.Health = math.min(humanoid.Health + healAmount, humanoid.MaxHealth) -- Ensure health doesn't exceed max
	end
end

-- Helper function to get nearby zombies within a certain radius
local function getNearbyZombies(zombieData, position, radius)
	local nearbyZombies = {}
	for _, otherZombieData in zombieData.allZombies do
		local otherZombie = otherZombieData.model
		if
			otherZombie
			and otherZombie.Parent
			and otherZombie:FindFirstChild("HumanoidRootPart")
		then
			local distance = (otherZombie.HumanoidRootPart.Position - position).Magnitude
			if distance <= radius and otherZombie ~= zombieData.model then
				table.insert(nearbyZombies, otherZombie)
			end
		end
	end
	return nearbyZombies
end

local attackTypes = {
	basic = function(zombieData, id)
		local npc = zombieData.model -- NPC model
		local attackPower = zombieData.attackPower -- Damage to deal
		local attackRange = 3 -- Attack range in studs

		if not npc or not npc.Parent or not npc.PrimaryPart then
			return
		end

		-- Check if the zombie can attack based on debounce
		if not canAttack(id) then
			return
		end

		-- Find the closest player
		local player = findClosestTarget(npc:GetPivot().Position)

		if not player or not player.Character or not player.Character.PrimaryPart then
			return
		end

		-- Calculate distance between zombie and player
		local distanceToPlayer = (npc.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude

		-- Ensure player is within attack range (3 studs)
		if distanceToPlayer <= attackRange then
			-- Apply damage to the player
			applyDamageToPlayer(player, attackPower)
		end
	end,

	fire = function(zombieData, id)
		local npc = zombieData.model
		local attackPower = zombieData.attackPower
		local burnDamage = zombieData.burnDamage or 5
		local burnDuration = zombieData.burnDuration or 5

		if not npc or not npc.Parent or not npc.PrimaryPart then
			return
		end

		-- Check if the zombie can attack based on debounce
		if not canAttack(id) then
			return
		end

		-- Find the closest player within range
		local player = findClosestTarget(npc:GetPivot().Position)

		-- Apply initial attack damage
		applyDamageToPlayer(player, attackPower)

		-- Apply burn effect (damage over time)
		for i = 1, burnDuration do
			task.wait(1)
			applyDamageToPlayer(player, burnDamage)
		end
	end,
}

local zombieSpecials = {
	spectre = function(zombieData, id)
		local npc = zombieData.model

		-- Check if the zombie is valid
		if not npc or not npc.Parent or not npc.PrimaryPart then
			return
		end

		-- Set initial transparency
		local function setTransparency(parent, transparency)
			for _, v in parent:GetChildren() do
				if v:IsA("BasePart") then
					v.Transparency = transparency
				end
			end
		end

		setTransparency(npc, 0.8)

		-- Phase in and out of invisibility every 4 seconds
		while npc.Parent do
			setTransparency(npc, 0.8)
			task.wait(4)
			setTransparency(npc, 1) -- Fully invisible
			task.wait(4)
		end
	end,

	angel = function(zombieData, id)
		local npc = zombieData.model
		local healRadius = 10 -- Radius of the healing pulse
		local healAmount = 50 -- Amount healed to nearby zombies
		local healCooldown = 3 -- Pulse every 3 seconds

		if not npc or not npc.Parent or not npc.PrimaryPart then
			return
		end

		-- Emit healing pulse every 3 seconds
		while npc.Parent and npc.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead do
			-- Get all nearby zombies within the heal radius
			local nearbyZombies = getNearbyZombies(zombieData, npc.PrimaryPart.Position, healRadius)

			-- Heal each nearby zombie
			for _, nearbyZombie in nearbyZombies do
				healZombie(nearbyZombie, healAmount)
			end

			task.wait(healCooldown) -- Wait before the next pulse
		end
	end,

	-- Lightning zombie with lightning bolt attack
	lightning = function(zombieData, id)
		local npc = zombieData.model
		local lightningRange = 10
		local healthDrain = 0.05

		if not npc or not npc.Parent or not npc.PrimaryPart then
			return
		end

		-- Check if the zombie can attack based on debounce
		if not canAttack(id) then
			return
		end

		-- Find the closest player within range
		while npc.Parent and npc.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead do
			local player = findClosestTarget(npc:GetPivot().Position)

			if
				(npc:GetPivot().Position - player.Character:GetPivot().Position).Magnitude
				<= lightningRange
			then
				local damage = player.Character.Humanoid.MaxHealth * healthDrain
				applyDamageToPlayer(player, damage)
				task.wait(1)
			end
			task.wait()
		end
	end,
}

local function pathfindChase(zombieData, id)
	local npc = zombieData.model -- NPC model
	local humanoid: Humanoid = npc:FindFirstChild("Humanoid")

	-- Ensure the humanoid exists
	if not humanoid then
		warn("Zombie has no humanoid")
		return
	end

	-- Ensure PrimaryPart is set, wait if necessary
	if not npc.PrimaryPart then
		local rootPart = npc:FindFirstChild("HumanoidRootPart")
			or npc:FindFirstChildWhichIsA("BasePart")
		if rootPart then
			npc.PrimaryPart = rootPart -- Set PrimaryPart to the root part or any available base part
		else
			warn("Zombie has no valid PrimaryPart or HumanoidRootPart")
			return
		end
	end

	-- Activate zombie special abilities
	if zombieData.specialAbility then
		task.spawn(zombieSpecials[zombieData.specialAbility], zombieData, id)
	end

	-- Create the pathfinding object
	local path = PathfindingService:CreatePath({
		AgentRadius = 2.25,
		AgentHeight = 5.5,
		AgentCanJump = true,
		AgentJumpHeight = 30,
		AgentCanClimb = true,
		AgentMaxSlope = 80,
	})

	local lastTargetPosition = nil
	local currentWaypointIndex = 0 -- Recalculate path if target moved significantly or every 2 seconds
	local waypoints = {}

	-- Debounce to prevent excessive pathfinding calculations
	local recalculationCooldown = 0.75 -- Slightly increased cooldown to prevent rapid recalculation
	local randomJumpCooldown = math.random(2, 5) -- Initial random cooldown for jumping between 2 and 5 seconds
	local lastJumpTime = 0 -- Track when the zombie last jumped
	local lastPathCalculation = 0 -- Track last path calculation time
	local PREDICTION_TIME_FACTOR = 1 -- Adjust how far into the future to predict
	local ATTACK_RANGE = 3 -- The range within which the zombie can attack

	local function hasLineOfSight(target, targetPosition)
		-- Cast a ray from the zombie's position to the target position to check for line of sight
		local ray = Ray.new(
			npc.PrimaryPart.Position,
			(targetPosition - npc.PrimaryPart.Position).Unit * 500
		)
		local hitPart = workspace:FindPartOnRay(ray, npc)

		-- If the ray hits nothing or the hit part is part of the target, the zombie has line of sight
		return not hitPart or hitPart:IsDescendantOf(target.Character)
	end

	local function waypointsContainJumps()
		for _, waypoint in ipairs(waypoints) do
			if waypoint.Action == Enum.PathWaypointAction.Jump then
				return true
			end
		end
		return false
	end

	local function chase()
		-- Ensure NPC and its PrimaryPart are valid
		if not npc or not npc.Parent or not npc.PrimaryPart then
			return
		end

		-- Find the closest target to the zombie
		local target = findClosestTarget(npc.PrimaryPart.Position)
		if target then
			local targetChar = target.Character
			-- Ensure target character and PrimaryPart are valid
			if targetChar and targetChar.PrimaryPart then
				local targetPosition = targetChar.PrimaryPart.Position
				local targetVelocity = targetChar.PrimaryPart.AssemblyLinearVelocity

				-- Predict the future position of the target
				local predictedPosition = targetPosition + (targetVelocity * PREDICTION_TIME_FACTOR)

				if not lastTargetPosition then
					lastTargetPosition = predictedPosition
				end

				-- Check if the zombie has line of sight and no waypoints contain jumps
				if hasLineOfSight(target, predictedPosition) and not waypointsContainJumps() then
					-- Move directly towards the player
					humanoid:MoveTo(predictedPosition)
				else
					-- Regular pathfinding behavior
					if
						(tick() - lastPathCalculation) >= recalculationCooldown
						or (predictedPosition - lastTargetPosition).Magnitude > 7 -- Increased magnitude for recalculation
					then
						lastPathCalculation = tick() -- Update the last calculation time

						local success, errorMessage = pcall(function()
							path:ComputeAsync(npc.PrimaryPart.Position, predictedPosition)
						end)

						if success then
							if path.Status == Enum.PathStatus.Success then
								-- If pathfinding is successful, get waypoints and continue
								waypoints = path:GetWaypoints()
								lastTargetPosition = predictedPosition
								currentWaypointIndex = #waypoints >= 3 and 3 or #waypoints
							elseif path.Status == Enum.PathStatus.NoPath then
								-- Handle NoPath scenario by moving directly towards the predicted position
								humanoid:MoveTo(predictedPosition)
								humanoid.Jump = true
								lastTargetPosition = predictedPosition
								if (tick() - lastJumpTime) >= randomJumpCooldown then
									humanoid.Jump = true -- Make the zombie jump
									lastJumpTime = tick() -- Update the last jump time
									randomJumpCooldown = math.random(2, 5) -- Reset the cooldown to a new random value
								end
								return
							end
						else
							-- Pathfinding error
							warn("Pathfinding error: " .. errorMessage)
							return
						end
					end

					-- Waypoint processing logic with minimum distance
					local MIN_WAYPOINT_DISTANCE = 2 -- Minimum distance between waypoints

					-- Inside chase() function after checking if there are waypoints
					if #waypoints > 0 and currentWaypointIndex <= #waypoints then
						local waypoint = waypoints[currentWaypointIndex]

						-- If close to current waypoint, move to the next one
						if not npc.PrimaryPart then
							return
						end
						local distanceToWaypoint = (npc.PrimaryPart.Position - waypoint.Position).Magnitude

						-- Skip to the next waypoint if it's too close
						if
							distanceToWaypoint < MIN_WAYPOINT_DISTANCE
							and currentWaypointIndex < #waypoints
						then
							currentWaypointIndex += 1
						end

						-- Move the humanoid to the current waypoint
						humanoid:MoveTo(waypoints[currentWaypointIndex].Position)

						-- Handle jumping if the waypoint requires it
						if waypoint.Action == Enum.PathWaypointAction.Jump then
							humanoid.Jump = true
						end
					else
						-- No waypoints, move directly to the predicted target position as a fallback
						lastTargetPosition = predictedPosition
						humanoid:MoveTo(predictedPosition)
					end
				end

				-- Check if the zombie is close enough to attack
				if (npc.PrimaryPart.Position - predictedPosition).Magnitude <= ATTACK_RANGE then
					if humanoid.Health > 0 then
						-- Call the attack logic based on the zombie's attack type
						attackTypes[zombieData.attackType or "basic"](zombieData, id)
					end
				end
			end
		end
	end

	-- Function to handle MoveToFinished
	local function onMoveToFinished(reached)
		-- Smooth transition: Move to the next waypoint without stopping
		if currentWaypointIndex > 0 and currentWaypointIndex < #waypoints then
			currentWaypointIndex += 1
			humanoid:MoveTo(waypoints[currentWaypointIndex].Position)
		else
			-- If no more waypoints are left, move directly to the target
			if lastTargetPosition then
				humanoid:MoveTo(lastTargetPosition)
			end
		end
	end

	-- Use Stepped for regular pathfinding checks
	local steppedConnection
	steppedConnection = RunService.Stepped:Connect(function()
		if not npc or not npc.Parent then
			steppedConnection:Disconnect()
			return
		end
		chase()
	end)

	humanoid.MoveToFinished:Connect(onMoveToFinished)
end

local M = {
	-- Data structure to hold common properties
	{
		Zombie = {
			health = 100,
			speed = 10,
			attackPower = 15,
			beginSpawningRound = 1,
			xpDropped = 10,
			moneyDropped = 4,
		},

		["Enchanted"] = {
			health = 200,
			attackPower = 20,
			speed = 14,
			beginSpawningRound = 3,
			xpDropped = 12,
			moneyDropped = 10,
		},

		["Fallen Angel"] = {
			health = 300,
			speed = 14,
			attackPower = 25,
			beginSpawningRound = 20,
			xpDropped = 20,
			moneyDropped = 15,
			specialAbility = "angel",
		},

		["Lightning Zombie"] = {
			health = 100,
			speed = 20,
			attackPower = 20,
			beginSpawningRound = 12,
			xpDropped = 13,
			moneyDropped = 9,
			specialAbility = "lightning",
		},

		["Blue Lightning Zombie"] = {
			health = 100,
			speed = 22,
			attackPower = 20,
			beginSpawningRound = 20,
			xpDropped = 20,
			moneyDropped = 9,
			specialAbility = "lightning",
		},

		["Spectre"] = {
			health = 80,
			speed = 14,
			attackPower = 40,
			beginSpawningRound = 15,
			xpDropped = 15,
			moneyDropped = 9,
			specialAbility = "spectre",
		},

		-- ["Mini"] = {
		-- 	health = 80,
		-- 	speed = 18,
		-- 	attackPower = 15,
		-- 	beginSpawningRound = 3,
		-- 	xpDropped = 8,
		-- 	moneyDropped = 2,
		-- },

		["Demon"] = {
			health = 250,
			speed = 14,
			attackPower = 25, -- plus burn
			beginSpawningRound = 20,
			xpDropped = 18,
			moneyDropped = 12,
			attackType = "fire",
		},

		["Flame Zombie"] = {
			health = 100,
			speed = 16,
			attackPower = 20, -- plus burn
			beginSpawningRound = 10,
			xpDropped = 13,
			moneyDropped = 7,
			attackType = "fire",
		},

		["Water Zombie"] = {
			health = 100,
			speed = 16,
			attackPower = 20,
			beginSpawningRound = 10,
			xpDropped = 13,
			moneyDropped = 10,
		},

		["Enraged"] = {
			health = 100,
			speed = 16,
			attackPower = 20,
			beginSpawningRound = 5,
			xpDropped = 10,
			moneyDropped = 10,
		},
	},
	{
		-- Pathfinding and AI logic
		basic = {
			chase = pathfindChase,
		},
	},
}

return M
