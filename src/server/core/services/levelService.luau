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

local levelService = {}

function levelService.canRebirth(player: Player)
	local playerProfile = playerDataService.getProfile(player)
	local level = playerProfile.Data.Level
	local rebirth = playerProfile.Data.Rebirth

	if level < 100 + rebirth * 100 then
		return false
	end

	return true
end

function levelService.rebirth(player: Player)
	local playerProfile = playerDataService.getProfile(player)
	playerProfile.Data.Level = 1
	playerProfile.Data.Experience = 0
	playerProfile.Data.Rebirth += 1 -- Increment rebirth count

	zap.updateLevelUi.Fire(player, {
		level = 1,
		xp = 0,
		xpMax = xpForLevel(2),
	})

	playerDataService.setProfile(player, playerProfile)
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
