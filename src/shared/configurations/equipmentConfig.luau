local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local equipmentFolder = RunService:IsServer() and ServerStorage.Equipment

local EquipmentConfig = {
	Grenade = {
		serverAction = function(player, targetPosition)
			-- Handle server-side action like damage, explosion, etc.
			local character = player.Character
			if not (character and character.Parent) then
				return
			end

			-- Create and position the grenade at the player's position
			local grenadeClone = equipmentFolder.Grenade:Clone()
			grenadeClone.Position = character.HumanoidRootPart.Position + Vector3.new(0, 5, 0) -- Spawn slightly above the player
			grenadeClone.Parent = workspace

			-- Add velocity to the grenade towards the target position
			local direction = (targetPosition - grenadeClone.Position).unit
			local grenadeVelocity = Instance.new("BodyVelocity")
			grenadeVelocity.Velocity = direction * 50 -- Adjust the force as needed
			grenadeVelocity.MaxForce = Vector3.new(4000, 4000, 4000) -- Max force in all directions
			grenadeVelocity.Parent = grenadeClone

			-- Set a timer for the grenade to explode
			task.delay(3, function() -- Grenade explodes after 3 seconds
				-- Explosion logic here
				local explosion = Instance.new("Explosion")
				explosion.Position = grenadeClone.Position
				explosion.BlastRadius = 10 -- Adjust radius as needed
				explosion.BlastPressure = 5000 -- Adjust damage pressure
				explosion.Parent = workspace

				-- Clean up the grenade after the explosion
				grenadeClone:Destroy()
			end)
		end,
	},

	Medkit = {
		serverAction = function(player: Player)
			-- Heal the player on the server
			local character = player.Character
			if character and character.Parent then
				local humanoid = character:WaitForChild("Humanoid")
				if not humanoid then
					return
				end
				humanoid.Health = humanoid.MaxHealth
			end
		end,
	},
	BubbleShield = {
		serverAction = function(player)
			-- Create a bubble shield around the player
			local DURATION = 4

			local char = player.Character
			if not (char and char.Parent) then
				return
			end

			local ff = Instance.new("ForceField")
			ff.Parent = player.Character

			task.delay(DURATION, function()
				ff:Destroy()
			end)
		end,
	},
}

return EquipmentConfig
