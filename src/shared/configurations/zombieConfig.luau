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
	local path = PathfindingService:CreatePath({
		AgentRadius = 2.25,
		AgentHeight = 5.5,
		AgentCanJump = true,
		AgentJumpHeight = 7,
		AgentCanClimb = false,
	})

	local lastTargetPosition = nil
	local currentWaypointIndex = 0
	local waypoints = {}

	local function startChasing()
		if not npc or not npc.Parent or not npc.PrimaryPart then
			return
		end
		local target = findClosestTarget(npc.PrimaryPart.Position)
		if target then
			local targetChar = target.Character
			local targetPosition = targetChar.PrimaryPart.Position

			-- Recalculate path only if the target moved significantly
			if lastTargetPosition == nil or (targetPosition - lastTargetPosition).Magnitude > 5 then
				path:ComputeAsync(npc.PrimaryPart.Position, targetPosition)
				lastTargetPosition = targetPosition
				waypoints = path.Status == Enum.PathStatus.Success
						and Sift.Array.slice(
							path:GetWaypoints(),
							3, -- Skip to the 3rd waypoint to avoid stutter steps
							#path:GetWaypoints()
						)
					or {}
				currentWaypointIndex = 1
			end

			local humanoid = npc:FindFirstChild("Humanoid")
			if not humanoid then
				return
			end

			-- Move towards the next waypoint or directly to the target if no path
			if #waypoints > 0 then
				npc.Humanoid:MoveTo(waypoints[currentWaypointIndex].Position)
			else
				npc.Humanoid:MoveTo(targetPosition)
			end

			-- Check if the zombie is within attack range and attack the player
			local attackRange = 2
			-- Ensure the zombie has a Humanoid and is not dead
			if npc and npc.PrimaryPart then
				if (npc.PrimaryPart.Position - targetPosition).Magnitude <= attackRange then
					if not humanoid or humanoid.Health <= 0 then
						return -- Zombie is dead or doesn't have a Humanoid component
					end
					attackTypes[zombieData.attackType or "basic"](zombieData, id) -- Call the attack function when within range
				end
			end
		end
	end

	local function onMoveToFinished()
		if currentWaypointIndex > 0 and currentWaypointIndex < #waypoints then
			currentWaypointIndex += 1
			npc.Humanoid:MoveTo(waypoints[currentWaypointIndex].Position)
		else
			-- Recalculate path on the next frame
			startChasing()
		end
	end

	-- Set up the event listener to trigger on each step
	local steppedConnection
	steppedConnection = RunService.Stepped:Connect(function()
		-- Stop tracking if NPC is destroyed
		if not npc or not npc.Parent then
			steppedConnection:Disconnect()
			return
		end
		startChasing()
	end)

	-- Listen for when the NPC finishes moving
	npc.Humanoid.MoveToFinished:Connect(onMoveToFinished)
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
		},

		["Enchanted"] = {
			health = 200,
			attackPower = 20,
			speed = 14,
			beginSpawningRound = 3,
			xpDropped = 12,
		},

		["Fallen Angel"] = {
			health = 300,
			speed = 14,
			attackPower = 25,
			beginSpawningRound = 20,
			xpDropped = 20,
		},

		["Midnight"] = {
			health = 50,
			speed = 10,
			attackPower = 45,
			beginSpawningRound = 3,
			xpDropped = 15,
		},

		["Lightning Zombie"] = {
			health = 100,
			speed = 20,
			attackPower = 20,
			beginSpawningRound = 12,
			xpDropped = 13,
		},

		["Blue Lightning Zombie"] = {
			health = 100,
			speed = 22,
			attackPower = 20,
			beginSpawningRound = 12,
			xpDropped = 20,
		},

		["Spectre"] = {
			health = 80,
			speed = 14,
			attackPower = 40,
			beginSpawningRound = 15,
			xpDropped = 15,
		},

		["Mini"] = {
			health = 80,
			speed = 18,
			attackPower = 15,
			beginSpawningRound = 3,
			xpDropped = 8,
		},

		["Demon"] = {
			health = 250,
			speed = 14,
			attackPower = 25, -- plus burn
			beginSpawningRound = 20,
			xpDropped = 18,
		},

		["Flame Zombie"] = {
			health = 100,
			speed = 16,
			attackPower = 20, -- plus burn
			beginSpawningRound = 10,
			xpDropped = 13,
		},

		["Water Zombie"] = {
			health = 100,
			speed = 16,
			attackPower = 20,
			beginSpawningRound = 10,
			xpDropped = 13,
		},

		["Enraged"] = {
			health = 100,
			speed = 16,
			attackPower = 20,
			beginSpawningRound = 5,
			xpDropped = 10,
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
