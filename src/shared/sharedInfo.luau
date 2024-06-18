local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.sharedPackages.Signal)

-- For shared information / enums
return {
	Gamepasses = {
		["2x Energy"] = 757577410,
		["2x Pet Storage"] = 755074444,
		["VIP"] = 756914380,
		["Auto Hatch"] = 757009460,
		["Basic Luck"] = 755908425,
		["Mega Luck"] = 755612353,
		["Ultra Luck"] = 755255465,
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
