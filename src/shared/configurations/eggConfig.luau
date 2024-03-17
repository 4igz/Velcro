type EggName = string
type Weight = number
type PetName = string

type Egg = {
	[EggName]: {
		pets: {
			[PetName]: Weight,
		},

		cost: number,
	},
}

return {
	-- Higher weight = Lower chance
	basic = {
		pets = {
			Dog = 1,
			Cat = 3,
			Elephant = 50,
			Giraffe = 300,
		},

		cost = 10,
	},
	otherEggName = {
		pets = {
			["PetName"] = 100,
		},

		cost = 100,
	},
}
