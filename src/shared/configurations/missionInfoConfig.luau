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
	cash = "cash",
}

local rewards = {
	cash = "cash",
	xp = "xp",
}

return {
	rewards = rewards,
	requirements = requirements,
	types = types,
}
