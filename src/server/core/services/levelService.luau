local ServerStorage = game:GetService("ServerStorage")

local services = ServerStorage.server.services

local playerDataService = require(services.playerDataService)
local zap = require(ServerStorage.zap)

local BASE_EXPERIENCE = 25

local levelService = { client = {} }

function levelService.levelFromExperience(xp, baseXp, growthRate)
	-- Set default values if not provided
	baseXp = baseXp or 100
	growthRate = growthRate or 1.2

	if xp <= 0 then
		return 1
	end

	-- Calculate the level using the logarithmic formula
	local level = math.log(xp / baseXp + 1) / math.log(growthRate)
	return math.floor(level)
end

function levelService.levelCost(level, base_xp, growth_rate)
	-- Set default values if not provided
	base_xp = base_xp or 100
	growth_rate = growth_rate or 1.2

	if level <= 1 then
		return base_xp -- Base XP required for level 1
	end

	-- Calculate the total experience required for the given level
	local xp = base_xp * math.pow(growth_rate, level - 1)
	return math.floor(xp)
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

	local currentLevel = playerProfile.Data.Level
	local xpForNextLevel = levelService.levelCost(currentLevel + 1)

	if playerProfile.Data.Experience > xpForNextLevel then
		playerProfile.Data.Level += 1
	end

	playerProfile.Data.Experience += amt

	zap.updateLevelUi.Fire(player, {
		level = playerProfile.Data.Level,
		xp = playerProfile.Data.Experience, -- total XP
		xpMax = levelService.levelCost(playerProfile.Data.Level + 1), -- XP required to reach the next level
	})

	playerDataService.setProfile(player, playerProfile)
end

function levelService.getLevelData(player: Player)
	local playerProfile = playerDataService.getProfile(player)
	local level = playerProfile.Data.Level
	local xpForNextLevel = levelService.levelCost(level + 1)

	return { level = level, xp = playerProfile.Data.Experience, xpMax = xpForNextLevel }
end

function levelService.start()
	zap.getLevelData.SetCallback(function(player)
		local levelData = levelService.getLevelData(player)
		return levelData
	end)
end

return levelService
