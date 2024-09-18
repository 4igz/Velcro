local ServerStorage = game:GetService("ServerStorage")

local services = ServerStorage.server.services

local playerDataService = require(services.playerDataService)
local zap = require(ServerStorage.zap)

local a, b, c = 500, 150, 200 -- Constants for logarithmic part
local expFactor = 1.05 -- Exponential factor for later levels
local transitionLevel = 100 -- Level where exponential growth begins

-- Experience required for the logarithmic part (before transition level)
local function xpForLogLevel(level)
	return a * math.log(level) + b * level + c
end

-- Experience required for the exponential part (after transition level)
local function xpForExpLevel(level)
	return a * math.log(transitionLevel)
		+ b * transitionLevel
		+ c
		+ ((level - transitionLevel) ^ expFactor) * b
end

local function xpForLevel(level)
	if level < transitionLevel then
		return xpForLogLevel(level)
	else
		return xpForExpLevel(level)
	end
end

local function getLevel(xp)
	-- Calculate XP at the transition level
	local xpAtTransition = xpForLogLevel(transitionLevel)

	if xp < xpAtTransition then
		-- Inverse logarithmic formula to calculate the level directly
		return math.floor(math.exp((xp - c) / a))
	else
		-- Inverse exponential formula for levels beyond the transition level
		return math.floor(((xp - xpAtTransition) / b) ^ (1 / expFactor) + transitionLevel)
	end
end

local levelService = { client = {} }

-- function levelService.levelFromExperience(xp, baseXp, growthRate)
-- 	-- Set default values if not provided
-- 	baseXp = baseXp or 100
-- 	growthRate = growthRate or 1.2

-- 	if xp <= 0 then
-- 		return 1
-- 	end

-- 	-- Calculate the level using the logarithmic formula
-- 	local level = math.log(xp / baseXp + 1) / math.log(growthRate)
-- 	return math.floor(level)
-- end

-- function levelService.levelCost(level, base_xp, growth_rate)
-- 	-- Set default values if not provided
-- 	base_xp = base_xp or 100
-- 	growth_rate = growth_rate or 1.2

-- 	if level <= 1 then
-- 		return base_xp -- Base XP required for level 1
-- 	end

-- 	-- Calculate the total experience required for the given level
-- 	local xp = base_xp * math.pow(growth_rate, level - 1)
-- 	return math.floor(xp)
-- end

function levelService.costLeftToNextLevel(experience: number): number
	if experience - 1 == experience then -- math.huge
		return 0
	end

	local currentLevel = getLevel(experience)
	local experienceRequired = xpForLevel(currentLevel)

	return experienceRequired - experience
end

function levelService.addExperience(player: Player, amt: number)
	local playerProfile = playerDataService.getProfile(player)

	local currentLevel = playerProfile.Data.Level
	local xpForNextLevel = xpForLevel(currentLevel + 1)

	if playerProfile.Data.Experience > xpForNextLevel then
		playerProfile.Data.Level += 1
	end

	playerProfile.Data.Experience += amt

	zap.updateLevelUi.Fire(player, {
		level = playerProfile.Data.Level,
		xp = playerProfile.Data.Experience, -- total XP
		xpMax = xpForLevel(playerProfile.Data.Level + 1), -- XP required to reach the next level
	})

	playerDataService.setProfile(player, playerProfile)
end

function levelService.getLevelData(player: Player)
	local playerProfile = playerDataService.getProfile(player)
	local level = playerProfile.Data.Level
	local xpForNextLevel = xpForLevel(level + 1)

	return { level = level, xp = playerProfile.Data.Experience, xpMax = xpForNextLevel }
end

function levelService.start()
	zap.getLevelData.SetCallback(function(player)
		local levelData = levelService.getLevelData(player)
		return levelData
	end)
end

return levelService
