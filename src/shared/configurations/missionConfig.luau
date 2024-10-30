local missionInfoConfig = require(script.Parent.missionInfoConfig)

local requirements = missionInfoConfig.requirements
local rewards = missionInfoConfig.rewards
-- What you are collecting/killing
local goal = missionInfoConfig.types

return {
	{
		name = "Kill Zombies",

		-- Mission Info
		goals = { 10, 100, 1000, 10000 },
		requirement = requirements.kill,
		type = goal.zombies,

		-- Reward Info
		reward = rewards.coins,
		rewards = { 100, 1_000, 10_000, 1_000_000 },
	},

	{
		name = "Kill Elite Zombies",

		-- Mission Info
		goals = { 1, 10, 100 },
		requirement = requirements.kill,
		type = goal.elites,

		-- Reward Info
		reward = rewards.coins,
		rewards = { 10_000, 100_000, 1_000_000 },
	},

	{
		name = "Get Coins",

		-- Mission Info
		goals = { 1_000, 10_000, 100_000, 1_000_000 },
		requirement = requirements.collect,
		type = goal.coins,

		-- Reward Info
		reward = rewards.xp,
		rewards = { 100, 1000, 10_000, 100_000 },
	},

	{
		name = "Rebirth",

		-- Mission Info
		goals = { 1 },
		requirement = requirements.rebirth,
		type = goal.rebirth,

		-- Reward Info
		reward = rewards.coins,
		rewards = { 25_000 },
	},
}
