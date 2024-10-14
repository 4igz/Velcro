export type ShopConfig = {
	price: number,
	levelReq: number,
	description: string,
	order: number, -- this variable will order it in the ui correctly
}

return {
	shotgun = {
		["Jacket-3"] = {
			price = 5000,
			levelReq = 20,
			description = "<b>Level: 20</b>\nThe starting shotgun. Perfect for quick burst of damage into crowds!",
			order = 1,
		},
		["Super90"] = {
			price = 50000,
			levelReq = 100,
			description = "<b>Level: 100</b>\nI thought those zombies were hard. Well not anymore...",
			order = 13,
		},
	},
	smg = {
		["SMG"] = {
			price = 5000,
			levelReq = 20,
			description = "<b>Level: 20</b>\nYour classic high firerate arsenal. Let them eat lead!",
			order = 2,
		},
		["VC-S"] = {
			price = 20000,
			levelReq = 50,
			description = "<b>Level: 50</b>\nThe better SMG",
			order = 5,
		},
		["VP70"] = {
			price = 30500,
			levelReq = 70,
			description = "<b>Level: 70</b>\nLIGHT EM UP BOYS",
			order = 10,
		},
	},
	rifle = {
		["PM12"] = {
			price = 27500,
			levelReq = 60,
			description = "<b>Level: 60</b>\nZombies? WHERE.",
			order = 7,
		},
		["AR57"] = {
			price = 50000,
			levelReq = 100,
			description = "<b>Level: 100</b>\nWHERE. ARE. THEY.",
			order = 14,
		},
	},
	sniper = {
		["Moisin"] = {
			price = 5000,
			levelReq = 20,
			description = "<b>Level: 20</b>\nHigh damage, slow firerate. But why stick to shooting only 1 zombie?",
			order = 3,
		},
		["AWP"] = {
			price = 20000,
			levelReq = 50,
			description = "<b>Level: 50</b>\nWhy be far and weak, when you can be close and strong.",
			order = 6,
		},
		["BNT-2"] = {
			price = 25000,
			levelReq = 60,
			description = "<b>Level: 60</b>\nZombies? WHERE.",
			order = 8,
		},
		["BFG-5000"] = {
			price = 30500,
			levelReq = 70,
			description = "<b>Level: 70</b>\nYou're only a pile of flesh now..",
			order = 9,
		},
		["Laserbadger"] = {
			price = 50000,
			levelReq = 100,
			description = "<b>Level: 100</b>\nPew pew said the gun",
			order = 12,
		},
	},
	pistol = {
		["Starter Pistol"] = {
			price = 0,
			levelReq = 0,
			description = "<b>Level: 0</b>\nOld Reliable",
			order = 0,
		},
		["Deagle"] = {
			price = 50000,
			levelReq = 100,
			description = "<b>Level: 100</b>\nNuh uh",
			order = 11,
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
