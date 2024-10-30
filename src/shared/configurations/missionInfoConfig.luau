local requirements = {
	kill = "kill",
	collect = "collect",
	rebirth = "rebirth",
}

-- In other words, what you are collecting/killing
local types = {
	zombies = "zombies",
	elites = "elites",
	rebirth = "rebirth",
	coins = "coins",
}

local rewards = {
	coins = "coins",
	xp = "xp",
}

return {
	rewards = rewards,
	requirements = requirements,
	types = types,
}
