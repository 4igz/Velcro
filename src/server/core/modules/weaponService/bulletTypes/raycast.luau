local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Sift = require(ReplicatedStorage.sharedPackages.Sift)
local instanceUtil = require(ReplicatedStorage.shared.utilities.instanceUtil)
local weaponSettings = require(ReplicatedStorage.shared.configurations.weaponConfig)
local zap = require(ServerStorage.zap)

local TAU = math.pi * 2

local rng = Random.new()
local bulletHitSignal = weaponSettings.signals.bulletHit

local CastParams = RaycastParams.new()
CastParams.IgnoreWater = true
CastParams.FilterType = Enum.RaycastFilterType.Include
CastParams.FilterDescendantsInstances = {}

return function(
	shooter: Player,
	ws: weaponSettings.Settings,
	firepoint: Attachment,
	to: Vector3,
	hitPart: Instance,
	weaponName: string
)
	local character = shooter.Character
	local head = character and character:FindFirstChild("Head")
	if not head then
		return
	end
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid or humanoid:GetState() == Enum.HumanoidStateType.Dead then
		return
	end

	-- Get all models tagged with "Zombie"
	local zombieModels = CollectionService:GetTagged("Zombie")

	-- Create a new raycast params and set it to whitelist only zombie parts
	local rayParams: RaycastParams = CastParams
	rayParams.FilterDescendantsInstances = { zombieModels }

	local raysToVisualize = {}
	local hitsToProcess = {} -- Store all raycast results here
	local headPosition = head.Position
	local headToTarget = (to - headPosition).Unit

	-- Cache frequently used math calculations
	local minSpreadRad = math.rad(ws.minBulletSpreadAngle :: number)
	local maxSpreadRad = math.rad(ws.maxBulletSpreadAngle :: number)
	local range = ws.range
	local rngNext = rng.NextNumber -- Cache RNG function

	-- Store frequently used values to avoid recalculating them inside the loop
	local bulletsToFire = ws.bullets
	local maxPierce = ws.maxPierce
	local damageDecrementFactor = 0.5

	-- Create a counter to track active coroutines
	local activeCoroutines = 0

	-- Create a function to process the hit data once all coroutines finish
	local function processHitData()
		for _, hitData in hitsToProcess do
			local ray = hitData.raycastResult
			bulletHitSignal:Fire(shooter, ws, ray, weaponName)
		end

		if ws.bullets > 1 then
			-- Batch visualizations in one go to reduce latency
			for _, rayData in raysToVisualize do
				zap.replicateCast.Fire(shooter, rayData)
			end
		end
	end

	for _ = 1, bulletsToFire do
		-- Increment active coroutines counter
		activeCoroutines += 1

		-- Calculate bullet direction with spread in a coroutine
		task.spawn(function()
			local spreadAngle = rngNext(rng, minSpreadRad, maxSpreadRad)
			local randomAngle = rngNext(rng, 0, TAU)

			-- Final direction calculation with the bullet spread
			local direction = (CFrame.new(Vector3.new(), headToTarget) * CFrame.fromOrientation(
				0,
				0,
				randomAngle
			) * CFrame.fromOrientation(spreadAngle, 0, 0)).LookVector * range

			local currentPosition = headPosition
			local remainingRange = range
			local damage = ws.damage
			local hits = 0
			local iterationLimit = maxPierce

			local ray

			while iterationLimit > 0 and hits < maxPierce and remainingRange > 0 do
				ray = workspace:Raycast(currentPosition, direction, rayParams)

				if ray then
					local hitInstance = ray.Instance
					local hitCharacter = instanceUtil.ancestorWithTag(hitInstance, "Zombie")

					-- If a hit occurs, store the raycast result for later processing
					if hitCharacter then
						hits = hits + 1
						table.insert(hitsToProcess, {
							raycastResult = ray,
						})

						-- Decrease the damage for subsequent hits (if piercing is allowed)
						damage = damage * damageDecrementFactor
					end

					-- Update remaining range based on travel distance
					local travelDistance = (ray.Position - currentPosition).Magnitude
					remainingRange = remainingRange - travelDistance

					-- Exit if no range remains
					if remainingRange <= 0 then
						break
					end

					currentPosition = ray.Position
					direction = direction.Unit * remainingRange
				else
					break -- No ray hit, exit early
				end

				iterationLimit = iterationLimit - 1
			end

			-- Store ray visualization info
			raysToVisualize[#raysToVisualize + 1] = {
				firepoint = firepoint,
				hit = ray and ray.Position or headPosition + direction,
				beamColor = ws.raycastBeamColor,
			}

			-- Decrement active coroutines counter and check if all coroutines are done
			activeCoroutines -= 1
			if activeCoroutines == 0 then
				processHitData() -- Process hits when all coroutines are finished
			end
		end)
	end

	-- If no coroutines were started (edge case), process hit data immediately
	if activeCoroutines == 0 then
		processHitData()
	end
end
