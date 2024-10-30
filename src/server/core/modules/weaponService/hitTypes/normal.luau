local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local services = ServerStorage.server.services

local ZOMBIE_TAG = "Zombie"

local playerDataService = require(ServerStorage.server.services.playerDataService)
local skillService = require(services.skillService)
local weaponSettings = require(ReplicatedStorage.shared.configurations.weaponConfig)
local zap = require(ServerStorage.zap)

-- Global table to track which zombies have already been killed
local zombieKillTracker = {}
local zombieKillLocks = {} -- Table to prevent zombies from being killed twice

-- Function to handle zombie hit by player
return function(shooter: Player, ws: weaponSettings.Settings, raycastResult: RaycastResult)
	local hitZombie
	if raycastResult and raycastResult.Instance then
		local character = raycastResult.Instance.Parent
		if CollectionService:HasTag(character, ZOMBIE_TAG) then
			hitZombie = character
		end
	end

	-- Check if a zombie was hit
	if hitZombie then
		local hitHumanoid: Humanoid = hitZombie:FindFirstChildOfClass("Humanoid")
		if not hitHumanoid or hitHumanoid:GetState() == Enum.HumanoidStateType.Dead then
			return
		end

		zombieKillTracker[hitZombie] = zombieKillTracker[hitZombie] or {}

		if zombieKillLocks[hitZombie] then
			return
		end

		if not zombieKillTracker[hitZombie][shooter.UserId] then
			local isCritical = false
			if raycastResult.Instance.Name == "Head" then
				ws.damage *= ws.headshotMultiplier
				isCritical = true
			end
			-- Apply skills (player effects, weapon changes, area-based effects, etc.)
			-- Player hasn't killed this zombie yet, deal damage with modified weapon settings
			hitHumanoid:TakeDamage(ws.damage)
			skillService.trackHitZombie(shooter, hitZombie)
			skillService.trackHeadshotHit(shooter, hitZombie, raycastResult.Instance)
			skillService.applySkills(shooter, ws)

			zap.replicateHit.Fire(
				shooter,
				{ hitPart = raycastResult.Instance, damage = ws.damage, isCritical = isCritical }
			)

			if hitHumanoid:GetState() == Enum.HumanoidStateType.Dead or hitHumanoid.Health <= 0 then
				zombieKillTracker[hitZombie][shooter.UserId] = true

				weaponSettings.signals.kill:Fire(shooter, hitZombie, ws)
			end
		end
	end
end
