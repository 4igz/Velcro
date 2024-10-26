local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local weaponConfig = require(ReplicatedStorage.shared.configurations.weaponConfig)
local zombieConfig = require(ReplicatedStorage.shared.configurations.zombieConfig)
local signals = zombieConfig[3]
local equipmentService = {}
local equipmentFolder = ServerStorage.Equipment

function equipmentService.start()
	weaponConfig.signals.kill:Connect(function(shooter, hitZombie, ws)
		print("Zombie died")

		-- Randomly drop equipment, which are powerups
		local equipment = equipmentFolder:GetChildren()
		local randomEquipment = equipment[math.random(1, #equipment)]
		local equipmentClone = randomEquipment:Clone()
		equipmentClone.PrimaryPart.Position = hitZombie.PrimaryPart.Position
		equipmentClone.PrimaryPart.Anchored = true
		equipmentClone.Parent = workspace
	end)
end

return equipmentService
