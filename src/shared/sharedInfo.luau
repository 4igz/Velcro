local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.sharedPackages.Signal)

-- For shared information / enums
return {
	pickupCreated = Signal.new(),

	Example = {
		"Example1",
		"Example2",
		"Example3",
	},
}
