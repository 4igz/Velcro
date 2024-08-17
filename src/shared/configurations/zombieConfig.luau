local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Sift = require(ReplicatedStorage.sharedPackages.Sift)

--[[ Example
module.standardPathfindSettings 	= {			-- optimized for default dummies.
	AgentRadius = 2.25, 	-- default 2
	AgentHeight = 5.5, 		-- default 5
	AgentCanJump = true,	-- default true
	AgentCanClimb = false,	-- default false
	Cost = {}				-- default {}
}		-- should your AI get stuck on corners, tweak these as followed in https://create.roblox.com/docs/characters/pathfinding (Agent-Radius, etc..).

]]

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

local M = {
	-- Data structure to hold common properties
	{
		Zombie = {
			health = 100,
			speed = 10,
			attackPower = 15,
			position = Vector3.new(0, 0, 0),
			beginSpawningRound = 1,
			aiType = "basic",
		},

		-- Example of extending properties for a specific zombie type
		SpecialZombie = {
			attackPower = 20,
			aiType = "special",
			beginSpawningRound = 3,
		},
	},
	{
		-- Pathfinding and AI logic
		basic = {
			chase = function(zombieData, id)
				local npc = zombieData.model -- NPC model
				local path = PathfindingService:CreatePath({
					AgentRadius = 2,
					AgentHeight = 5,
					AgentCanJump = true,
					AgentJumpHeight = 7,
					AgentMaxSlope = 45,
					AgentCanClimb = false,
				})

				local lastTargetPosition = nil
				local currentWaypointIndex = 0
				local waypoints = {}

				local function startChasing()
					if not npc or not npc.Parent then
						return
					end
					local target = findClosestTarget(npc.PrimaryPart.Position)
					if target then
						local targetChar = target.Character
						local targetPosition = targetChar.PrimaryPart.Position

						-- Recalculate path only if the target moved significantly
						if
							lastTargetPosition == nil
							or (targetPosition - lastTargetPosition).Magnitude > 5
						then
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
			end,
		},
		-- Special AI logic for special zombies
		special = {
			initialize = function(zombieData, id)
				local zombieModel = zombieData.model
				local moveSpeed = zombieData.moveSpeed or 10

				-- Use the helper function to find the closest player
				local closestPlayer = findClosestTarget(zombieModel.PrimaryPart.Position)
				if closestPlayer then
					local targetPosition = closestPlayer.Character.HumanoidRootPart.Position

					-- Move the zombie towards the closest player using pathfinding
					moveZombieWithPathfinding(zombieModel, targetPosition, moveSpeed)
				end
			end,
		},
	},
}

return M
