local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local startup = require(ReplicatedStorage.shared.utilities.startup)

startup(ServerStorage.server.services, ServerStorage.server.components)
	:andThen(function()
		_G.loaded = true
		print("All server modules loaded.")
	end)
	:expect()
