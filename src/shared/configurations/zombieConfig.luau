local PathfindingService = game:GetService("PathfindingService")

-- Helper function to find the closest player to the given position
local function findClosestPlayer(zombiePosition)
	local Players = game:GetService("Players")
	local closestPlayer = nil
	local minDistance = math.huge

	-- Iterate over all players to find the closest one
	for _, player in Players:GetPlayers() do
		local playerCharacter = player.Character
		if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
			local playerPosition = playerCharacter.HumanoidRootPart.Position
			local distance = (playerPosition - zombiePosition).magnitude
			if distance < minDistance then
				minDistance = distance
				closestPlayer = player
			end
		end
	end

	return closestPlayer
end

-- Helper function to move the zombie directly towards a target position
local function moveZombieDirectly(zombieModel, targetPosition, moveSpeed)
	if not zombieModel or not zombieModel.PrimaryPart then
		return
	end
	local zombiePosition = zombieModel.PrimaryPart.Position

	-- Calculate the direction from the zombie to the target
	local direction = (targetPosition - zombiePosition).unit

	-- Set the zombie's CFrame to look at the target while moving towards them
	zombieModel:PivotTo(CFrame.new(zombiePosition, targetPosition))

	-- Move the zombie towards the target
	zombieModel.PrimaryPart.CFrame = zombieModel.PrimaryPart.CFrame + direction * moveSpeed
end

-- Helper function to move the zombie using pathfinding towards a target position
local function moveZombieWithPathfinding(zombieModel, targetPosition, moveSpeed)
	if not zombieModel or not zombieModel.PrimaryPart then
		return
	end
	local zombiePosition = zombieModel.PrimaryPart.Position

	-- Create a path from the zombie's position to the target position
	local path = PathfindingService:CreatePath({
		Start = zombiePosition,
		Finish = targetPosition,
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true,
	})

	path:ComputeAsync(zombiePosition, targetPosition)
	local waypoints = path:GetWaypoints()

	-- Move the zombie towards the next waypoint if available
	if #waypoints > 1 then
		local nextWaypoint = waypoints[2]
		if nextWaypoint then
			local direction = (nextWaypoint.Position - zombiePosition).unit

			-- Set the zombie's CFrame to look at the next waypoint
			zombieModel:SetPrimaryPartCFrame(CFrame.new(zombiePosition, nextWaypoint.Position))

			-- Move the zombie towards the next waypoint
			zombieModel.PrimaryPart.CFrame = zombieModel.PrimaryPart.CFrame + direction * moveSpeed
		end
	end
end

local M = {
	{
		-- Data structure to hold common properties
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
		basic = {
			update = function(zombieData, id)
				local zombieModel = zombieData.model
				local moveSpeed = zombieData.moveSpeed or 10

				-- Use the helper function to find the closest player
				local closestPlayer = findClosestPlayer(zombieModel.PrimaryPart.Position)
				if closestPlayer then
					local targetPosition = closestPlayer.Character.HumanoidRootPart.Position

					-- Move the zombie directly towards the closest player
					moveZombieDirectly(zombieModel, targetPosition, moveSpeed)
				end
			end,
		},
		special = {
			update = function(zombieData, id)
				local zombieModel = zombieData.model
				local moveSpeed = zombieData.moveSpeed or 10

				-- Use the helper function to find the closest player
				local closestPlayer = findClosestPlayer(zombieModel.PrimaryPart.Position)
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
