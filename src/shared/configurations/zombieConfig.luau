local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local vfxFolder = ServerStorage.VFX
local FastCast = require(ReplicatedStorage.sharedPackages.FastCast)
local PartCache = require(ReplicatedStorage.shared.utilities.PartCache)
local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local fogCycle = require(ServerStorage.server.services.fogCycleService)

local skillService = require(ServerStorage.server.services.skillService)
local zombieStatConfig = require(script.Parent.zombieStatConfig)
local zombieUtil = require(ReplicatedStorage.shared.utilities.zombieUtil)
local attackCooldown = 2 -- Cooldown time in seconds between attacks
local zombieDebounces = {} -- Table to store the debounce status for each zombie

local spitterCaster = FastCast.new()
spitterCaster.PartCache = PartCache.new(vfxFolder.AcidSpit, 10, workspace.Terrain)

local behavior = FastCast.newBehavior()
behavior.RaycastParams = RaycastParams.new()
behavior.MaxDistance = 100
behavior.Acceleration = Vector3.new(0, -workspace.Gravity / 4, 0)
behavior.CosmeticBulletContainer = workspace.Terrain
behavior.CosmeticBulletProvider = spitterCaster.PartCache
behavior.CanPierceFunction = function(cast, result, hitPos)
	if result.Instance then
		if result.Instance:IsDescendantOf(workspace.MapContainer) then
			return false
		end
		return Players:GetPlayerFromCharacter(result.Instance.Parent) == nil
	else
		return true
	end
end

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
		local skillData = skillService.getSkillData(player, "Dodging")
		if skillService.getEquippedWeaponClass(player) == "pistol" and skillData.level > 0 then
			-- Added 5% chance to dodge per level
			if math.random(1, 100) <= (skillData.level * 5) then
				return
			end
		end
		humanoid:TakeDamage(damage)
	end
end

-- Helper function for attack debouncing
local function canAttack(zombieId, cd)
	local currentTime = tick()

	-- Initialize debounce table if it doesn't exist
	if not zombieDebounces[zombieId] then
		zombieDebounces[zombieId] = { ["lastAttackTime"] = 0 }
	end

	-- Check cooldown
	if currentTime - zombieDebounces[zombieId].lastAttackTime >= (cd or attackCooldown) then
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

spitterCaster.LengthChanged:Connect(function(cast, lastPoint, dir, displacment, segVel, pellet)
	pellet.CFrame = CFrame.lookAt(lastPoint + (dir * displacment), lastPoint)
end)

spitterCaster.RayHit:Connect(function(cast, result, segVel, pellet)
	local acidSpitDamage = 10

	if result.Instance then
		cast.UserData.pellet = pellet
		local character = result.Instance:FindFirstAncestorWhichIsA("Model")
		local humanoid = character and character:FindFirstChild("Humanoid")
		if humanoid then
			local player = Players:GetPlayerFromCharacter(character)
			if player then
				applyDamageToPlayer(player, acidSpitDamage)
			end
		end
	end
end)

spitterCaster.CastTerminating:Connect(function(cast)
	local cosmeticBullet = cast.RayInfo.CosmeticBulletObject
	if cosmeticBullet ~= nil then
		behavior.CosmeticBulletProvider:ReturnPart(cosmeticBullet)
	end
end)

local attackTypes = {
	basic = function(zombieData, id, target)
		local npc = zombieData.model -- NPC model
		local attackPower = zombieData.attackPower -- Damage to deal

		if not npc or not npc.Parent or not npc.PrimaryPart then
			return
		end

		if not target or not target.Character or not target.Character.PrimaryPart then
			return
		end

		-- Ensure player is within attack range (3 studs)
		-- Check if the zombie can attack based on debounce
		if not canAttack(id) then
			return
		end
		-- Apply damage to the player
		applyDamageToPlayer(target, attackPower)
	end,

	fire = function(zombieData, id, target)
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

		-- Apply initial attack damage
		applyDamageToPlayer(target, attackPower)

		-- Apply burning vfx
		for _, part in target.Character:GetDescendants() do
			if part:IsA("BasePart") then
				local fire = vfxFolder.Fire:Clone()
				for _, v in fire:GetChildren() do
					if v:IsA("ParticleEmitter") then
						v = v:Clone()
						v.Parent = part
						task.delay(burnDuration, function()
							v:Destroy()
						end)
					end
				end
			end
		end

		-- Apply burn effect (damage over time)
		for i = 1, burnDuration do
			task.wait(1)
			applyDamageToPlayer(target, burnDamage)
		end
	end,
}

local zombieSpecials = {
	devil = function(zombieData, id) end,
	spit = function(zombieData, id)
		-- This zombie will shoot acid spit at nearby players
		local npc = zombieData.model
		local acidSpitSpeed = 100
		local acidSpitCooldown = 3
		local acidSpitRange = 100

		if not npc or not npc.Parent or not npc.PrimaryPart then
			return
		end

		-- Check if the zombie can attack based on debounce
		if not canAttack(id, acidSpitCooldown) then
			return
		end

		-- Find the closest player within range
		while npc.Parent and npc.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead do
			local player = findClosestTarget(npc:GetPivot().Position)

			local character = player.Character
			if
				(npc:GetPivot().Position - character:GetPivot().Position).Magnitude
				<= acidSpitRange
			then
				local direction = (character:GetPivot().Position - npc:GetPivot().Position).Unit
				spitterCaster:Fire(npc.Head.Position, direction, acidSpitSpeed, behavior)
			end
			task.wait(acidSpitCooldown)
		end
	end,

	spectre = function(zombieData, id)
		local npc = zombieData.model

		-- Check if the zombie is valid
		if not npc or not npc.Parent or not npc.PrimaryPart then
			return
		end

		-- Set initial transparency
		local function setTransparency(parent, transparency)
			for _, v in parent:GetDescendants() do
				if v:IsA("BasePart") then
					v.Transparency = transparency
				elseif v:IsA("ParticleEmitter") then
					if transparency < 1 then
						v.Enabled = true
					else
						v.Enabled = false
					end
				end
			end
		end

		setTransparency(npc, 0.8)

		-- Phase in and out of invisibility every 4 seconds
		while npc.Parent do
			setTransparency(npc, 0.8)
			task.wait(3)
			-- now make vfx invisible too
			setTransparency(npc, 1) -- Fully invisible
			task.wait(2)
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
			local nearbyZombies =
				zombieUtil.getNearbyZombies(zombieData, npc.PrimaryPart.Position, healRadius)

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
			task.wait(1)
		end
	end,
}

local function pathfindChase(zombieData, id)
	local npc = zombieData.model
	local humanoid: Humanoid = npc:FindFirstChild("Humanoid")

	if not humanoid then
		warn("Zombie has no humanoid")
		return
	end

	-- Ensure PrimaryPart is set
	if not npc.PrimaryPart then
		local rootPart = npc:FindFirstChild("HumanoidRootPart")
			or npc:FindFirstChildWhichIsA("BasePart")
		if rootPart then
			npc.PrimaryPart = rootPart
		else
			warn("Zombie has no valid PrimaryPart or HumanoidRootPart")
			return
		end
	end

	-- Trigger zombie's special abilities if any
	if zombieData.specialAbility then
		task.spawn(zombieSpecials[zombieData.specialAbility], zombieData, id)
	end

	local path = PathfindingService:CreatePath({
		AgentRadius = 2.25,
		AgentHeight = 5,
		AgentCanJump = true,
		AgentJumpHeight = 7.2,
		AgentCanClimb = true,
		AgentMaxSlope = 89,
	})

	local lastTargetPosition = nil
	local currentWaypointIndex = 0
	local waypoints = {}

	local recalculationCooldown = 1.5
	local randomJumpCooldown = math.random(1, 3)
	local lastJumpTime = 0
	local lastPathCalculation = 0
	local lastLineOfSightCheck = 0
	local lineOfSightCheckInterval = 0.25
	local PREDICTION_TIME_FACTOR = zombieData.prediction and 1
		or if fogCycle.fogEnabled then 1 else 0
	local ATTACK_RANGE = 3.5

	local function hasLineOfSight(target, targetPosition)
		local ray = Ray.new(
			npc.PrimaryPart.Position,
			(targetPosition - npc.PrimaryPart.Position).Unit * 500
		)
		local hitPart = workspace:FindPartOnRay(ray, npc)
		return not hitPart or hitPart:IsDescendantOf(target.Character)
	end

	local function waypointsContainJumps()
		for _, waypoint in waypoints do
			if waypoint.Action == Enum.PathWaypointAction.Jump then
				return true
			end
		end
		return false
	end

	local function moveToTarget(predictedPosition)
		humanoid:MoveTo(predictedPosition)
		if (tick() - lastJumpTime) >= randomJumpCooldown then
			humanoid.Jump = true
			lastJumpTime = tick()
			randomJumpCooldown = math.random(1, 3)
		end
	end

	local function computePath(predictedPosition)
		local success, errorMessage = pcall(function()
			path:ComputeAsync(npc.PrimaryPart.Position, predictedPosition)
		end)

		if success and path.Status == Enum.PathStatus.Success then
			waypoints = path:GetWaypoints()
			currentWaypointIndex = #waypoints >= 3 and 3 or #waypoints
			return true
		elseif path.Status == Enum.PathStatus.NoPath then
			moveToTarget(predictedPosition)
			return false
		else
			warn("Pathfinding error: " .. errorMessage)
			return false
		end
	end

	local function handleWaypoints(predictedPosition)
		local MIN_WAYPOINT_DISTANCE = 5

		if #waypoints > 0 and currentWaypointIndex <= #waypoints then
			local waypoint = waypoints[currentWaypointIndex]
			if not npc.PrimaryPart then
				return
			end
			local distanceToWaypoint = (npc.PrimaryPart.Position - waypoint.Position).Magnitude

			if distanceToWaypoint < MIN_WAYPOINT_DISTANCE and currentWaypointIndex < #waypoints then
				currentWaypointIndex += 1
			end

			humanoid:MoveTo(waypoints[currentWaypointIndex].Position)
			if waypoint.Action == Enum.PathWaypointAction.Jump then
				humanoid.Jump = true
			end
		else
			moveToTarget(predictedPosition)
		end
	end

	local function chase()
		if not npc or not npc.Parent or not npc.PrimaryPart then
			return
		end

		local target = findClosestTarget(npc.PrimaryPart.Position)
		if not target or not target.Character or not target.Character.PrimaryPart then
			return
		end

		local targetPosition = target.Character.PrimaryPart.Position
		local targetVelocity = target.Character.PrimaryPart.AssemblyLinearVelocity
		local predictedPosition = targetPosition + (targetVelocity * PREDICTION_TIME_FACTOR)

		if not lastTargetPosition then
			lastTargetPosition = predictedPosition
		end

		if (tick() - lastLineOfSightCheck) >= lineOfSightCheckInterval then
			lastLineOfSightCheck = tick()

			if hasLineOfSight(target, predictedPosition) and not waypointsContainJumps() then
				humanoid:MoveTo(predictedPosition)
			else
				if
					(tick() - lastPathCalculation) >= recalculationCooldown
					or (predictedPosition - lastTargetPosition).Magnitude > 7
				then
					lastPathCalculation = tick()
					computePath(predictedPosition)
				end

				handleWaypoints(predictedPosition)
			end
		end

		if not npc.PrimaryPart then
			return
		end
		if not target.Character then
			return
		end
		if
			(npc.PrimaryPart.Position - target.Character:GetPivot().Position).Magnitude
			<= ATTACK_RANGE
		then
			if humanoid.Health > 0 then
				attackTypes[zombieData.attackType or "basic"](zombieData, id, target)
			end
		end
	end

	local function onMoveToFinished(reached)
		if currentWaypointIndex > 0 and currentWaypointIndex < #waypoints then
			currentWaypointIndex += 1
			humanoid:MoveTo(waypoints[currentWaypointIndex].Position)
		elseif lastTargetPosition then
			humanoid:MoveTo(lastTargetPosition)
		end
	end

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
	[1] = zombieStatConfig,
	[2] = {
		-- Pathfinding and AI logic
		basic = {
			chase = pathfindChase,
		},
	},
	[3] = {
		zombieDied = Signal.new(),
	},
}

return M
