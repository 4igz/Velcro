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

local attackTypes = {
	basic = function(zombieData, id)
		local npc = zombieData.model -- NPC model
		local attackPower = zombieData.attackPower -- Damage to deal

		if not npc or not npc.Parent or not npc.PrimaryPart then
			return
		end

		-- Initialize the debounce table for this zombie if it doesn't exist
		if not zombieDebounces[id] then
			zombieDebounces[id] = {
				lastAttackTime = 0,
			}
		end

		-- Get the current time and compare it to the last attack time
		local currentTime = tick()
		if currentTime - zombieDebounces[id].lastAttackTime < attackCooldown then
			-- If the cooldown period hasn't passed, exit the function
			return
		end

		-- Update the last attack time
		zombieDebounces[id].lastAttackTime = currentTime

		-- Iterate over all players to find those within the attack range
		-- If the player is within the attack range, apply damage
		local player = findClosestTarget(npc:GetPivot().Position)

		local humanoid = player.Character.Humanoid
		humanoid:TakeDamage(attackPower)
	end,
}

local function pathfindChase(zombieData, id)
	local npc = zombieData.model -- NPC model
	local humanoid = npc:FindFirstChild("Humanoid")

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

	-- Create the pathfinding object
	local path = PathfindingService:CreatePath({
		AgentRadius = 2.25,
		AgentHeight = 5.5,
		AgentCanJump = true,
		AgentJumpHeight = 30,
		AgentCanClimb = true,
		AgentMaxSlope = 50,
	})

	local lastTargetPosition = nil
	local currentWaypointIndex = 0
	local waypoints = {}

	-- Function to start pathfinding chase
	local function startChasing()
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

				-- Recalculate path if target moved significantly
				if
					not lastTargetPosition
					or (targetPosition - lastTargetPosition).Magnitude > 5
				then
					local success, errorMessage = pcall(function()
						path:ComputeAsync(npc.PrimaryPart.Position, targetPosition)
					end)

					if success and path.Status == Enum.PathStatus.Success then
						waypoints = path:GetWaypoints()
						lastTargetPosition = targetPosition
						-- Start at the 3rd waypoint if there are enough waypoints
						currentWaypointIndex = #waypoints >= 3 and 3 or 1
					elseif not success then
						warn("Pathfinding error: " .. errorMessage)
						return
					end
				end

				-- Move to the next waypoint if it exists
				if #waypoints > 0 and currentWaypointIndex <= #waypoints then
					local waypoint = waypoints[currentWaypointIndex]
					humanoid:MoveTo(waypoint.Position)

					-- Handle jumping if the waypoint requires it
					if waypoint.Action == Enum.PathWaypointAction.Jump then
						humanoid.Jump = true -- Jump to higher ground
					end
				else
					-- No waypoints, move directly to the target position
					humanoid:MoveTo(targetPosition)
				end

				-- Check if the zombie is close enough to attack
				local attackRange = 2
				if not npc.PrimaryPart then
					return
				end
				if (npc.PrimaryPart.Position - targetPosition).Magnitude <= attackRange then
					if humanoid.Health > 0 then
						attackTypes[zombieData.attackType or "basic"](zombieData, id)
					end
				end
			end
		end
	end

	-- Function to handle MoveToFinished
	local function onMoveToFinished(reached)
		-- If the zombie reached the waypoint, go to the next one
		if reached and currentWaypointIndex > 0 and currentWaypointIndex < #waypoints then
			currentWaypointIndex += 1
			humanoid:MoveTo(waypoints[currentWaypointIndex].Position)
		else
			-- Recalculate the path if not reached or no waypoints
			startChasing()
		end
	end

	-- Use Stepped for regular pathfinding checks
	local steppedConnection
	steppedConnection = RunService.Stepped:Connect(function()
		if not npc or not npc.Parent then
			steppedConnection:Disconnect()
			return
		end
		startChasing()
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
		},

		-- ["Midnight"] = {
		-- 	health = 50,
		-- 	speed = 10,
		-- 	attackPower = 45,
		-- 	beginSpawningRound = 3,
		-- 	xpDropped = 15,
		-- 	moneyDropped = 10,
		-- },

		["Lightning Zombie"] = {
			health = 100,
			speed = 20,
			attackPower = 20,
			beginSpawningRound = 12,
			xpDropped = 13,
			moneyDropped = 9,
		},

		["Blue Lightning Zombie"] = {
			health = 100,
			speed = 22,
			attackPower = 20,
			beginSpawningRound = 20,
			xpDropped = 20,
			moneyDropped = 9,
		},

		["Spectre"] = {
			health = 80,
			speed = 14,
			attackPower = 40,
			beginSpawningRound = 15,
			xpDropped = 15,
			moneyDropped = 9,
		},

		["Mini"] = {
			health = 80,
			speed = 18,
			attackPower = 15,
			beginSpawningRound = 3,
			xpDropped = 8,
			moneyDropped = 2,
		},

		["Demon"] = {
			health = 250,
			speed = 14,
			attackPower = 25, -- plus burn
			beginSpawningRound = 20,
			xpDropped = 18,
			moneyDropped = 12,
		},

		["Flame Zombie"] = {
			health = 100,
			speed = 16,
			attackPower = 20, -- plus burn
			beginSpawningRound = 10,
			xpDropped = 13,
			moneyDropped = 7,
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
