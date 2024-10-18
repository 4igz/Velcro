local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.sharedPackages.Signal)

-- For shared information / enums
return {
	Gamepasses = {
		["+50 Health"] = 757577410,
		["Ultra VIP"] = 755074444,
		["VIP"] = 756914380,
		["Extra Speed!"] = 757009460, -- implemented
		["Heal every wave"] = 755908425,
		["2x Cash"] = 755612353,
		["2x XP"] = 755255465,
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

	UISignals = {
		deployed = Signal.new(),
	},
}
