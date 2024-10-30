export type ShopConfig = {
	price: number,
	levelReq: number,
	description: string,
	order: number, -- this variable will order it in the ui correctly
}

return {
	shotgun = {
		["Jacket-3"] = {
			price = 3000,
			levelReq = 5,
			description = "<b>Level: 5</b>\nThe starting shotgun. Perfect for quick burst of damage into crowds!",
			order = 1,
		},
		["BNT-2"] = {
			price = 7500,
			levelReq = 10,
			description = "<b>Level: 5</b>\nThe starting shotgun. Perfect for quick burst of damage into crowds!",
			order = 1,
		},
		["Super90"] = {
			price = 50000,
			levelReq = 50,
			description = "<b>Level: 50</b>\nI thought those zombies were hard. Well not anymore...",
			order = 13,
		},
	},
	smg = {
		["SMG"] = {
			price = 3000,
			levelReq = 5,
			description = "<b>Level: 5</b>\nYour classic high firerate arsenal. Let them eat lead!",
			order = 2,
		},
		["VC-S"] = {
			price = 10000,
			levelReq = 20,
			description = "<b>Level: 20</b>\nThe better SMG",
			order = 5,
		},
		["VP70"] = {
			price = 20500,
			levelReq = 50,
			description = "<b>Level: 50</b>\nLIGHT EM UP BOYS",
			order = 10,
		},
		["PM12"] = {
			price = 27000,
			levelReq = 70,
			description = "<b>Level: 70</b>\nNo more zombies",
			order = 9,
		},
		["AR57"] = {
			price = 45000,
			levelReq = 80,
			description = "<b>Level: 70</b>\nOk it's go timeS",
			order = 14,
		},
	},
	rifle = {
		["M4 Carbine"] = {
			price = 2500,
			levelReq = 5,
			description = "<b>Level: 5</b>\nSome Old lead shooting shenanigans",
			order = 1,
		},
		["Tommy Gun"] = {
			price = 5000,
			levelReq = 10,
			description = "<b>Level: 10</b>\nDecent firerate-damage ratio to create some zombie noddles!",
			order = 2,
		},
		["Scar-H"] = {
			price = 7500,
			levelReq = 20,
			description = "<b>Level: 20</b>\nThe casual zombie-destroying firearm",
			order = 3,
		},
		["Nova-9"] = {
			price = 10000,
			levelReq = 30,
			description = "<b>Level: 30</b>\nPure power",
			order = 4,
		},
		["Viper"] = {
			price = 20000,
			levelReq = 50,
			description = "<b>Level: 50</b>\nNow we're talking",
			order = 5,
		},
		["Annihilator"] = {
			price = 30000,
			levelReq = 60,
			description = "<b>Level: 60</b>\nPerfect gun for the maximum amount of death",
			order = 6,
		},
		["Nightfall"] = {
			price = 50000,
			levelReq = 100,
			description = "<b>Level: 100</b>\nWHERE. ARE. THEY.",
			order = 7,
		},
	},
	sniper = {
		["Moisin"] = {
			price = 3000,
			levelReq = 5,
			description = "<b>Level: 5</b>\nHigh damage, slow firerate. But why stick to shooting only 1 zombie?",
			order = 3,
		},
		["AWP"] = {
			price = 20000,
			levelReq = 30,
			description = "<b>Level: 30</b>\nWhy be far and weak, when you can be close and strong.",
			order = 6,
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
