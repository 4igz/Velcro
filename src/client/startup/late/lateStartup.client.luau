local ReplicatedStorage = game:GetService("ReplicatedStorage")

local startup = require(ReplicatedStorage.shared.utilities.startup)

startup(ReplicatedStorage.client.controllers, ReplicatedStorage.client.components)
	:andThen(function()
		_G.loaded = true
		print("All client modules loaded.")
	end)
	:catch(function(err)
		warn("Error starting client:", err)
	end)
