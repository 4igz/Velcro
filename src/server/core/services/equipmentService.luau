local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local equipmentConfig = require(ReplicatedStorage.shared.configurations.equipmentConfig)
local weaponConfig = require(ReplicatedStorage.shared.configurations.weaponConfig)
local zap = require(ServerStorage.zap)
local equipmentService = {}
local equipmentFolder = ServerStorage.Equipment
local dropFolder = ServerStorage.Drops

local playerEquipments = {}

local EQUIPMENT_DESPAWN_TIMER = 60
local DROP_PERCENT = 0.03
local MAX_EQUIPMENT_COUNT = 5

-- Initialize playerEquipments table when a player joins
Players.PlayerAdded:Connect(function(player)
	playerEquipments[player.UserId] = {}
end)

-- Clean up playerEquipments table when a player leaves
Players.PlayerRemoving:Connect(function(player)
	playerEquipments[player.UserId] = nil
end)

function equipmentService.start()
	zap.useEquipment.SetCallback(function(player: Player, data)
		local equipment = equipmentConfig[data.equipmentName]
		if not equipment then
			return
		end

		local char = player.Character
		if not char then
			return
		end
		playerEquipments[player.UserId][data.equipmentName] = playerEquipments[player.UserId][data.equipmentName]
			or 0
		if playerEquipments[player.UserId][data.equipmentName] >= 1 then
			equipment.serverAction(player, data.hitPos)
			playerEquipments[player.UserId][data.equipmentName] -= 1
			zap.updateEquipments.Fire(player, playerEquipments[player.UserId])
		end
	end)

	-- Handle equipment drops when a zombie is killed and equipment pick ups
	weaponConfig.signals.kill:Connect(function(shooter: Player, hitZombie, ws)
		if not hitZombie then
			return
		end

		-- Randomly drop equipment, which are powerups
		local drops = dropFolder:GetChildren()
		local equipmentDrop = drops[math.random(1, #drops)]:Clone()
		local equipmentName = equipmentDrop.Name
		if math.random() > (equipmentConfig[equipmentName].dropRate or DROP_PERCENT) then
			return
		end

		local zombiePosition = hitZombie.HumanoidRootPart.Position

		-- Define the ray parameters
		local rayOrigin = zombiePosition
		local rayDirection = Vector3.new(0, -10, 0)
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances =
			{ workspace.Terrain, workspace.Zombies, hitZombie }
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

		if raycastResult then
			local floorPosition = raycastResult.Position + Vector3.new(0, 2, 0)
			equipmentDrop:PivotTo(CFrame.new(floorPosition))
		else
			equipmentDrop:PivotTo(CFrame.new(zombiePosition))
		end

		equipmentDrop.Parent = workspace

		local primaryPart = equipmentDrop.PrimaryPart :: BasePart
		local pickedUp = false

		primaryPart.Touched:Connect(function(part)
			local player = Players:GetPlayerFromCharacter(part.Parent)
			if not player or pickedUp then
				return
			end
			pickedUp = true
			equipmentDrop:Destroy()

			if equipmentConfig[equipmentName].immediateAction then
				equipmentConfig[equipmentName].immediateAction(player)
				return
			end

			-- Check if the player can pick up more of this equipment
			playerEquipments[player.UserId][equipmentName] = playerEquipments[player.UserId][equipmentName]
				or 0
			if playerEquipments[player.UserId][equipmentName] < MAX_EQUIPMENT_COUNT then
				-- Add equipment to the player's inventory and increment the count
				playerEquipments[player.UserId][equipmentName] += 1
				zap.updateEquipments.Fire(player, playerEquipments[player.UserId])
			end
		end)

		task.delay(EQUIPMENT_DESPAWN_TIMER, function()
			if not pickedUp then
				equipmentDrop:Destroy()
			end
		end)
	end)
end

return equipmentService
