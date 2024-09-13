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
CastParams.FilterType = Enum.RaycastFilterType.Exclude
CastParams.FilterDescendantsInstances = {}

local TARGET_TAG = "ShootingTarget"

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

	local params: RaycastParams = CastParams
	params.FilterDescendantsInstances = { character, workspace.Terrain, workspace.RaycastIgnore }

	-- Table to store ray information for visualization
	local raysToVisualize = {}

	for _ = 1, ws.bullets do
		local direction = (
			CFrame.new(Vector3.new(), (to - head.Position).Unit)
			* CFrame.fromOrientation(0, 0, rng:NextNumber(0, TAU))
			* CFrame.fromOrientation(
				math.rad(rng:NextNumber(ws.minBulletSpreadAngle, ws.maxBulletSpreadAngle)),
				0,
				0
			)
		).LookVector * ws.range

		local ray
		local hits = 0
		local damage = ws.damage
		local currentPosition = head.Position
		local remainingRange = ws.range
		local hitTargets = {}
		local iterationLimit = ws.maxPierce

		repeat
			ray = workspace:Raycast(currentPosition, direction, params)

			if ray then
				local hitInstance = ray.Instance
				local hitCharacter = instanceUtil.ancestorWithTag(hitInstance, "Zombie")

				if hitCharacter and not hitTargets[hitCharacter] then
					-- Fire the signal for a valid hit
					Sift.Dictionary.merge(ws, { damage = damage })
					damage /= 2
					bulletHitSignal:Fire(shooter, ws, ray, weaponName)

					-- Exclude the hit part from further raycasts
					table.insert(params.FilterDescendantsInstances, hitInstance)

					hitTargets[hitCharacter] = true
					hits = hits + 1
				end

				-- Update remaining range
				local travelDistance = (ray.Position - currentPosition).Magnitude
				remainingRange = remainingRange - travelDistance

				if remainingRange <= 0 then
					break -- Exit loop if remaining range is depleted
				end

				currentPosition = ray.Position
				direction = direction.Unit * remainingRange
			else
				break -- Exit loop if no hit is detected
			end

			-- Decrement iteration limit and exit if it hits zero
			iterationLimit = iterationLimit - 1
			if iterationLimit <= 0 then
				break
			end

		until not ray or hits >= ws.maxPierce or remainingRange <= 0

		-- Add ray info to the list for visualization later
		table.insert(raysToVisualize, {
			firepoint = firepoint,
			hit = if ray then ray.Position else head.Position + direction,
			beamColor = ws.raycastBeamColor,
		})
	end

	-- Visualize all rays at once after the loop
	for _, rayData in ipairs(raysToVisualize) do
		zap.replicateCast.Fire(shooter, rayData)
	end
end
