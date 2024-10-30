local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local equipmentConfig = require(ReplicatedStorage.shared.configurations.equipmentConfig)
local weaponConfig = require(ReplicatedStorage.shared.configurations.weaponConfig)
local zap = require(ServerStorage.zap)
local zombieConfig = require(ReplicatedStorage.shared.configurations.zombieConfig)
local signals = zombieConfig[3]
local equipmentService = {}
local equipmentFolder = ServerStorage.Equipment
local dropFolder = ServerStorage.Drops

function equipmentService.start()
	zap.useEquipment.SetCallback(function(player: Player, data)
		local equipment = equipmentConfig[data.equipmentName]
		if not equipment then
			return
		end

		equipment.serverAction(player, data.hitPos)

		-- Equipment is one use
		local char = player.Character
		if not char then
			return
		end
		local eq = char:FindFirstChild(data.equipmentName)
		if not eq then
			eq = player.Backpack:FindFirstChild(data.equipmentName)
		end
		if eq then
			eq:Destroy()
		end
	end)

	-- Handle equipment drops when a zombie is killed and equipment pick ups
	weaponConfig.signals.kill:Connect(function(shooter: Player, hitZombie, ws)
		if not hitZombie then
			return
		end

		-- Only run 1% of the time
		if math.random() > 0.01 then
			return
		end

		-- Randomly drop equipment, which are powerups
		local equipment = equipmentFolder:GetChildren()
		local randomEquipment = equipment[math.random(1, #equipment)]

		local equipmentDrop: Model = dropFolder[randomEquipment.Name]:Clone()
		-- Set the position of the equipment drop to the zombie's position on the floor
		local zombiePosition = hitZombie.HumanoidRootPart.Position

		-- Define the ray parameters
		local rayOrigin = zombiePosition + Vector3.new(0, 0, 0) -- Start the ray slightly above the zombie
		local rayDirection = Vector3.new(0, -10, 0) -- Cast the ray downward

		-- Perform the raycast
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances =
			{ workspace.Terrain, workspace.Zombies, hitZombie }
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

		if raycastResult then
			local floorPosition = raycastResult.Position + Vector3.new(0, 2, 0)
			equipmentDrop:PivotTo(CFrame.new(floorPosition))
		else
			-- Fallback: If raycast fails, place at zombie's current Y position
			equipmentDrop:PivotTo(CFrame.new(zombiePosition))
		end

		-- Parent the equipmentDrop to the workspace so it appears in the game world
		equipmentDrop.Parent = workspace

		local primaryPart = equipmentDrop.PrimaryPart :: BasePart

		local pickedUp = false
		primaryPart.Touched:Connect(function(part)
			if not Players:GetPlayerFromCharacter(part.Parent) or pickedUp then
				return
			end
			pickedUp = true
			-- TODO: Pick up VFX
			equipmentDrop:Destroy()
			randomEquipment:Clone().Parent = shooter.Backpack
		end)
	end)
end

return equipmentService
