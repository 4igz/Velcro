local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local eggConfig = require(ReplicatedStorage.shared.configurations.eggConfig)
local monetizationUtil = require(ReplicatedStorage.shared.utilities.monetizationUtil)
local petConfig = require(ReplicatedStorage.shared.configurations.petConfig)
local playerDataService = require(ServerStorage.server.services.playerDataService)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local zap = require(ServerStorage.zap)

local rng = Random.new(tick())

local petService = {}

local DEFAULT_MAX_PETS = 30
local AMT_TO_FUSE = 5

function petService.start()
	zap.RollEgg.SetCallback(function(player, data)
		local eggName = data.eggName

		local cfg = eggConfig[eggName]
		local playerProfile = playerDataService.getProfile(player)

		local petAmt = DEFAULT_MAX_PETS

		if
			monetizationUtil.userOwnsGamepass(
				player.UserId,
				sharedInfo.Gamepasses["2x Pet Storage"]
			)
		then
			petAmt *= 2
		end

		if #playerProfile.Data.pets > petAmt then
			return
		end
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

	zap.FusePets.SetCallback(function(player, data)
		local playerData = playerDataService.getProfile(player)

		local pets = playerData.Data.pets

		-- Get all pets of same name and level
		local fusePets = petService.getSamePets(pets, data)

		-- If player has enough pets of same type and level then upgrade it
		if #fusePets > AMT_TO_FUSE then
			-- Create new pet
			local upgradedPet = table.clone(fusePets[1])
			upgradedPet.level += 1

			-- Remove old pets from pet table
			for _, info in fusePets do
				pets[info.index] = nil
			end

			table.insert(pets, upgradedPet)
		end

		playerDataService.setProfile(player, playerData)
	end)
end

function petService.getSamePets(petTable, petInfo)
	local pets = {}
	for i, info in petTable do
		if info.petName == petInfo.petName and info.level == petInfo.level then
			info.index = i
			table.insert(pets, petTable[i])
		end
	end
	return pets
end

return petService
