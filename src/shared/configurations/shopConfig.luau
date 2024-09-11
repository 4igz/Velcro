export type ShopConfig = {
	price: number,
	levelReq: number,
	description: string,
	order: number, -- this variable will order it in the ui correctly
}

return {
	gun = {
		["Sawed-Off Shotgun"] = {
			price = 1000,
			levelReq = 5,
			description = "The Swiss Army knife of the underworld",
			order = 1,
		},
		["Double Barrel Shotgun"] = {
			price = 2000,
			levelReq = 10,
			description = "Perfect for those indecisive moments when you can't choose between overkill and extreme overkill.",
			order = 2,
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
