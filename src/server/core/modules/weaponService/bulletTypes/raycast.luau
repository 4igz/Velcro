local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

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

		local ray = workspace:Raycast(head.Position, direction, params)
		local hitCharacter
		if ws.bullets == 1 then
			hitCharacter = if hitPart then instanceUtil.ancestorWithTag(hitPart, "Zombie") else nil
		else
			hitCharacter = if ray then instanceUtil.ancestorWithTag(ray.Instance, "Zombie") else nil
		end

		if hitCharacter then
			params.FilterDescendantsInstances = {
				character,
				workspace.Terrain,
				workspace.RaycastIgnore,
			}
			ray = workspace:Raycast(head.Position, direction, params)
		end

		if ray then
			bulletHitSignal:Fire(shooter, ws, ray, hitCharacter, weaponName)

			if instanceUtil.ancestorWithTag(hitPart, TARGET_TAG) then
				weaponSettings.signals.targetHit:Fire(shooter, weaponName)
			end
		end
	end
end
