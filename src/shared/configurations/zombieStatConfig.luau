return {
	Zombie = {
		health = 100,
		speed = 10,
		attackPower = 15,
		beginSpawningRound = 1,
		xpDropped = 10,
		moneyDropped = 10,
	},

	Devil = {
		health = 2000,
		speed = 10,
		attackPower = 50,
		beginSpawningRound = 16,
		xpDropped = 500,
		moneyDropped = 500,
		attackType = "fire",
		specialAbility = "devil",
		type = "elite",
	},

	["Enchanted"] = {
		health = 200,
		attackPower = 20,
		speed = 14,
		beginSpawningRound = 3,
		xpDropped = 12,
		moneyDropped = 15,
	},

	["Spitter"] = {
		health = 100,
		speed = 10,
		attackPower = 15,
		beginSpawningRound = 8,
		xpDropped = 20,
		moneyDropped = 20,
		specialAbility = "spit",
	},

	["Fallen Angel"] = {
		health = 300,
		speed = 14,
		attackPower = 25,
		beginSpawningRound = 15,
		xpDropped = 20,
		moneyDropped = 50,
		specialAbility = "angel",
	},

	["Lightning Zombie"] = {
		health = 100,
		speed = 20,
		attackPower = 20,
		beginSpawningRound = 10,
		xpDropped = 20,
		moneyDropped = 15,
		specialAbility = "lightning",
	},

	["Blue Lightning Zombie"] = {
		health = 100,
		speed = 22,
		attackPower = 20,
		beginSpawningRound = 20,
		xpDropped = 20,
		moneyDropped = 25,
		specialAbility = "lightning",
		prediction = true,
	},

	["Spectre"] = {
		health = 80,
		speed = 14,
		attackPower = 40,
		beginSpawningRound = 15,
		xpDropped = 15,
		moneyDropped = 20,
		specialAbility = "spectre",
		prediction = true,
	},

	-- ["Mini"] = {
	-- 	health = 80,
	-- 	speed = 18,
	-- 	attackPower = 15,
	-- 	beginSpawningRound = 3,
	-- 	xpDropped = 8,
	-- 	moneyDropped = 2,
	-- },

	["Demon"] = {
		health = 250,
		speed = 14,
		attackPower = 25, -- plus burn
		beginSpawningRound = 15,
		xpDropped = 18,
		moneyDropped = 22,
		attackType = "fire",
		prediction = true,
	},

	["Flame Zombie"] = {
		health = 100,
		speed = 16,
		attackPower = 20, -- plus burn
		beginSpawningRound = 10,
		xpDropped = 13,
		moneyDropped = 13,
		attackType = "fire",
	},

	["Water Zombie"] = {
		health = 100,
		speed = 16,
		attackPower = 20,
		beginSpawningRound = 10,
		xpDropped = 13,
		moneyDropped = 10,
	},

	["Enraged"] = {
		health = 100,
		speed = 16,
		attackPower = 20,
		beginSpawningRound = 5,
		xpDropped = 10,
		moneyDropped = 12,
		prediction = true,
	},
}
