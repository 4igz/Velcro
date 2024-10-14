local EquipmentConfig = {
	Grenade = {
		cooldown = 5, -- in seconds
		serverAction = function(player, targetPosition)
			-- Handle server-side action like damage, explosion, etc.
		end,
	},
	Medkit = {
		cooldown = 10,
		serverAction = function(player)
			-- Heal the player on the server
		end,
	},
	BubbleShield = {
		cooldown = 15,
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
