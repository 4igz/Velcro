local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local services = ServerStorage.server.services

local ZOMBIE_TAG = "Zombie"

local weaponSettings = require(ReplicatedStorage.shared.configurations.weaponConfig)

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

	if hitZombie then
		local hitHumanoid: Humanoid = hitZombie:FindFirstChildOfClass("Humanoid")
		if not hitHumanoid or hitHumanoid:GetState() == Enum.HumanoidStateType.Dead then
			return -- If the zombie is already dead, return
		end

		-- Ensure there's an entry in the kill tracker for this zombie
		zombieKillTracker[hitZombie] = zombieKillTracker[hitZombie] or {}

		-- Check if the zombie is globally marked as dead (already killed)
		if zombieKillLocks[hitZombie] then
			return -- If the zombie has already been killed, return early
		end

		-- Check if the player has already killed this zombie
		if not zombieKillTracker[hitZombie][shooter.UserId] then
			-- Player hasn't killed this zombie yet, deal damage and track the kill
			hitHumanoid:TakeDamage(
				if raycastResult.Instance.Name == "Head"
					then ws.damage * ws.headshotMultiplier
					else ws.damage
			)

			-- Defer kill handling to avoid race conditions
			if hitHumanoid:GetState() == Enum.HumanoidStateType.Dead or hitHumanoid.Health <= 0 then
				-- Mark that the player has killed this zombie
				zombieKillTracker[hitZombie][shooter.UserId] = true

				-- Trigger the kill event if the zombie dies
				weaponSettings.signals.kill:Fire(shooter, hitZombie, ws)
			end
		end
	end
end
