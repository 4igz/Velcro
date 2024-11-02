local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local zombieService = RunService:IsServer() and require(ServerStorage.server.services.zombieService)
local weaponConfig = require(script.Parent.weaponConfig)
local zombieUtil = require(ReplicatedStorage.shared.utilities.zombieUtil)

local equipmentParts = RunService:IsServer() and ServerStorage.EquipmentParts

local EquipmentConfig = {
	Grenade = {
		dropRate = 0.07,
		serverAction = function(player, targetPosition)
			-- Handle server-side action like damage, explosion, etc.
			local character = player.Character
			if not (character and character.Parent) then
				return
			end

			-- Create and position the grenade at the player's position
			local grenadeClone = equipmentParts.Grenade:Clone() :: BasePart
			grenadeClone.Position = character.HumanoidRootPart.Position + Vector3.new(1, 3, 2) -- Spawn slightly above the player
			grenadeClone.Parent = workspace.Weapons

			-- Add velocity to the grenade towards the target position
			local direction = (targetPosition - grenadeClone.Position).Unit
			grenadeClone:ApplyImpulse(direction * 50) -- Adjust impulse as needed

			local BLAST_RADIUS = 15
			local GRENADE_DAMAGE = 150
			-- Set a timer for the grenade to explode
			task.delay(1, function() -- Grenade explodes
				-- Explosion logic here
				local explosion = Instance.new("Explosion")
				explosion.Position = grenadeClone.Position
				explosion.BlastRadius = BLAST_RADIUS -- Adjust radius as needed
				explosion.BlastPressure = 5000 -- Adjust damage pressure
				explosion.DestroyJointRadiusPercent = 0
				explosion.Parent = workspace

				-- Damage nearby zombies
				local nearbyZombies = zombieUtil.getNearbyZombies(
					zombieService.getActiveZombies(),
					grenadeClone.Position,
					BLAST_RADIUS
				)

				for _, zombie in nearbyZombies do
					local humanoid = zombie:FindFirstChild("Humanoid")
					if humanoid then
						local con = humanoid.Died:Connect(function()
							-- Handle zombie death
							weaponConfig.signals.kill:Fire(player, zombie, nil)
						end)

						humanoid:TakeDamage(GRENADE_DAMAGE)

						-- Apply damage then give it some time for the event to fire if they die.
						task.delay(0.1, function()
							con:Disconnect()
						end)
					end
				end

				-- Damage nearby zombies

				-- Clean up the grenade after the explosion
				grenadeClone:Destroy()
			end)
		end,
	},
	Medkit = {
		dropRate = 0.02,
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
	Shield = {
		dropRate = 0.01,
		serverAction = function(player)
			-- Create a bubble shield around the player
			local DURATION = 15

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
	HealthDrop = {
		dropRate = 0.1,
		immediateAction = function(player)
			local character = player.Character
			if character and character.Parent then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.Health += 25
				end
			end
		end,
	},
}

return EquipmentConfig
