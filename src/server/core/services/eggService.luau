local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local eggConfig = require(ReplicatedStorage.shared.configurations.eggConfig)
local petConfig = require(ReplicatedStorage.shared.configurations.petConfig)
local playerDataService = require(ServerStorage.server.services.playerDataService)
local zap = require(ServerStorage.zap)

local rng = Random.new(tick())

local eggService = {}

function eggService.start()
	zap.RollEgg.SetCallback(function(player, data)
		local eggName = data.eggName

		local cfg = eggConfig[eggName]
		local playerProfile = playerDataService.getProfile(player)

		if playerProfile.Data.energy < cfg.cost then
			return
		end

		playerProfile.Data.energy -= cfg.cost

		-- Get the total weight of all pets
		local tw = 0 -- total weight
		local nameChanceMap = {}
		for petName, weight in cfg.pets do
			tw += 1 / weight
		end

		-- Now roll for pet
		local roll = rng:NextNumber(0, 1) / playerProfile.Data.petRollLuck
		local lowest = math.huge
		local rolledPet = ""
		for petName, weight in cfg.pets do
			local chance = 1 / weight
			if roll < chance and chance < lowest then
				lowest = chance
				rolledPet = petName
			end
		end

		print(`Rolled {roll} and got {rolledPet}!`)
		playerProfile.Data.pets[rolledPet] = petConfig[rolledPet]

		playerDataService.setProfile(player, playerProfile)
		return rolledPet
	end)
end

return eggService
