local ServerStorage = game:GetService("ServerStorage")

local services = ServerStorage.server.services

local playerDataService = require(services.playerDataService)

type LevelData = {
    level: number,
    experience: number,
}
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

function levelService.getLevelType(player: Player, levelType: string?): LevelData
    local playerProfile = playerDataService.getProfile(player)
    if not levelType then
        levelType = "Overall"
    end
    local level = playerProfile.Data.Levels[levelType]
    if not level then
        playerProfile.Data.Levels[levelType] = {
            level = 1,
            experience = 0,
        }
        playerDataService.setProfile(player, playerProfile)
    end
    return playerProfile.Data.Levels[levelType]
end

function levelService.addExperience(player: Player, levelType: string, additive: number)
    if levelType == "Overall" then
        warn("Overall level experience is handled automatically.")
        return
    end
    local playerProfile = playerDataService.getProfile(player)
    local overallLevel = playerProfile.Data.Levels.Overall
    local level = playerProfile.Data.Levels[levelType]

    if not level then -- New level types are created dynamically
        level = {
            level = 1,
            experience = 0,
        }
    end

    playerProfile.Data.Levels.Overall = {
        level = levelService.levelFromExperience(overallLevel.experience + additive),
        experience = overallLevel.experience + additive
    }

    playerProfile.Data.Levels[levelType] = {
        level = levelService.levelFromExperience(level.experience + additive),
        experience = level.experience + additive
    }

    playerDataService.setProfile(player, playerProfile)
end

return levelService
