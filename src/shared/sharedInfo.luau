local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.sharedPackages.Signal)

-- For shared information / enums
return {
	Gamepasses = {
		["2x Click"] = 4057761,
		["2x Pet Storage"] = 4057761,
	},

	GamepassBypass = {
		["2x Click"] = {
			-- 201659547,
		},
	},

	Example = {
		"Example1",
		"Example2",
		"Example3",
	},
}
