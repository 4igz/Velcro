export type PickupInfo = {
	island: string, -- Name of island that pickup generates on
	gatheringExperience: number, -- How much gathering experience player gets from pickup
	requiredLevel: number, -- Required gathering level to pick up
	pickupDistance: number, -- How far the player can be to pickup
	maxPickupsOnIsland: number, -- Max amount of pickups of this type on island
}

local pickupTypes: { [string]: PickupInfo } = {
	Rock = {
		island = "StoneAge",
		gatheringExperience = 5,
		requiredLevel = 0,
		pickupDistance = 5,
		maxPickupsOnIsland = 10,
	},
}

return pickupTypes
