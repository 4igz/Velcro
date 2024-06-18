local ServerStorage = game:GetService("ServerStorage")

local services = ServerStorage.server.services

local playerDataService = require(services.playerDataService)

local BASE_EXPERIENCE = 25

local levelService = { client = {} }

function levelService.levelFromExperience(experience: number): number
	return math.floor(
		(
			BASE_EXPERIENCE
			+ math.sqrt(BASE_EXPERIENCE * BASE_EXPERIENCE - 4 * BASE_EXPERIENCE * -experience)
		) / (2 * BASE_EXPERIENCE)
	)
end

function levelService.levelCost(level: number): number
	return BASE_EXPERIENCE * (level * (1 + level))
end

function levelService.costLeftToNextLevel(experience: number): number
	if experience - 1 == experience then -- math.huge
		return 0
	end

	local currentLevel = levelService.levelFromExperience(experience)
	local experienceRequired = levelService.levelCost(currentLevel)

	return experienceRequired - experience
end

function levelService.addExperience(player: Player, amt: number)
	local playerProfile = playerDataService.getProfile(player)
	local level = playerProfile.Data.Level
	local xp = playerProfile.Data.Experience

	playerProfile.Data.Level = levelService.levelFromExperience(xp + amt)
	playerProfile.Data.Experience = xp + amt

	playerDataService.setProfile(player, playerProfile)
end

return levelService
