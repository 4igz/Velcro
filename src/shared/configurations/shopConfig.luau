export type ShopConfig = {
	price: number,
	levelReq: number,
	description: string,
	order: number, -- this variable will order it in the ui correctly
}

return {
	gun = {
		["Starter Pistol"] = {
			price = 0,
			levelReq = 0,
			description = "Level: 0\nOld Reliable",
			order = 0,
		},

		-- 1st set of weapons
		["Jacket-3"] = {
			price = 5000,
			levelReq = 20,
			description = "Level: 20\nThe starting shotgun. Perfect for quick burst of damage into crowds!",
			order = 1,
		},
		["SMG"] = {
			price = 5000,
			levelReq = 20,
			description = "Level: 20\nYour classic high firerate arsenal. Let them eat lead!",
			order = 2,
		},
		["Moisin"] = {
			price = 5000,
			levelReq = 20,
			description = "Level: 20\nHigh damage, slow firerate. But why stick to shooting only 1 zombie?",
			order = 3,
		},
		-- ["Sawed-Off Shotgun"] = {
		-- 	price = 5000,
		-- 	levelReq = 20,
		-- 	description = "Level: 20\nThe Swiss Army knife of the underworld",
		-- 	order = 4,
		-- },

		-- 2nd set of weapons
		["VC-S"] = {
			price = 20000,
			levelReq = 50,
			description = "Level: 50\nThe better SMG",
			order = 5,
		},
		["AWP"] = {
			price = 20000,
			levelReq = 50,
			description = "Level: 50\nWhy be far and weak, when you can be close and strong.",
			order = 6,
		},
		["PM12"] = {
			price = 27500,
			levelReq = 60,
			description = "Level: 60\nZombies? WHERE.",
			order = 7,
		},
		["BNT-2"] = {
			price = 25000,
			levelReq = 60,
			description = "Level: 60\nZombies? WHERE.",
			order = 8,
		},
		["BFG-5000"] = {
			price = 30500,
			levelReq = 70,
			description = "Level: 70\nYou're only a pile of flesh now..",
			order = 9,
		},
		["VP70"] = {
			price = 30500,
			levelReq = 70,
			description = "Level: 70\nLIGHT EM UP BOYS",
			order = 10,
		},
		["Deagle"] = {
			price = 50000,
			levelReq = 100,
			description = "Level: 100\nNuh uh",
			order = 11,
		},
		["Laserbadger"] = {
			price = 50000,
			levelReq = 100,
			description = "Level: 100\nPew pew said the gun",
			order = 12,
		},
		["Super90"] = {
			price = 50000,
			levelReq = 100,
			description = "Level: 100\nI thought those zombies were hard. Well not anymore...",
			order = 13,
		},
		["AR57"] = {
			price = 50000,
			levelReq = 100,
			description = "Level: 100\nWHERE. ARE. THEY.",
			order = 14,
		},
	},
	melee = {
		["Katana"] = {
			price = 1000,
			levelReq = 5,
			description = "Perfect for those who appreciate the art of subtlety in their mayhem.",
			order = 1,
		},
	},
} :: { [string]: { [string]: ShopConfig } }
