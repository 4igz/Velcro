local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local zombieUtil = {}

zombieUtil.createShockwave = Signal.new()

function zombieUtil.getNearbyZombies(zombieData, position, radius)
	local nearbyZombies = {}
	for _, otherZombieData in (zombieData.allZombies and zombieData.allZombies or zombieData) do
		local otherZombie = otherZombieData.model
		if
			otherZombie
			and otherZombie.Parent
			and otherZombie:FindFirstChild("HumanoidRootPart")
		then
			local distance = (otherZombie.HumanoidRootPart.Position - position).Magnitude
			if
				distance <= radius
				and (zombieData.model and otherZombie ~= zombieData.model or true)
			then
				table.insert(nearbyZombies, otherZombie)
			end
		end
	end
	return nearbyZombies
end

return zombieUtil
