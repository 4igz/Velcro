local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local services = ServerStorage.server.services

local ZOMBIE_TAG = "Zombie"

local leaderboardService = require(services.leaderboardService)
local weaponSettings = require(ReplicatedStorage.shared.configurations.weaponConfig)
local weaponUtil = require(ReplicatedStorage.shared.utilities.weaponUtil)
local zap = require(ServerStorage.zap)

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
		if
			hitHumanoid and hitHumanoid:GetState() == Enum.HumanoidStateType.Dead
			or hitHumanoid.Health < 0
		then
			return
		end
		hitHumanoid:TakeDamage(ws.damage)
		leaderboardService.increment(shooter, "Damage", ws.damage)

		task.defer(function()
			if hitHumanoid:GetState() == Enum.HumanoidStateType.Dead or hitHumanoid.Health <= 0 then
				weaponSettings.signals.kill:Fire(shooter, hitZombie, ws)
			end
		end)
	end
end
