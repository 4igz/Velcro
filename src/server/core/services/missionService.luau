local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local levelService = require(script.Parent.levelService)
local missionConfig = require(ReplicatedStorage.shared.configurations.missionConfig)
local moneyService = require(script.Parent.moneyService)
local playerDataService = require(script.Parent.playerDataService)
local weaponConfig = require(ReplicatedStorage.shared.configurations.weaponConfig)
local zap = require(ServerStorage.zap)
local zombieStatConfig = require(ReplicatedStorage.shared.configurations.zombieStatConfig)

-- MissionService Module
local missionService = {}
local playerMissions = {}

-- Utility function to get current date in UTC
local function getCurrentDate()
	local utcTime = os.time(os.date("!*t"))
	return os.date("%Y-%m-%d", utcTime)
end

-- Initialize missions for a player
function missionService.initializePlayer(player)
	local profile = playerDataService.getProfile(player)
	local userId = player.UserId

	if not profile or not profile.Data then
		return
	end

	local currentDate = getCurrentDate()
	local lastMissionDate = profile.Data.missionDate or ""

	-- If it's a new day or player has no missions, generate new missions
	if currentDate ~= lastMissionDate or not profile.Data.missions then
		-- Select missions (you can adjust how many missions to assign)
		local missionIds = {}
		for missionId in missionConfig do
			table.insert(missionIds, missionId)
		end

		math.randomseed(tick())

		-- Shuffle the missionIds
		for i = #missionIds, 2, -1 do
			local j = math.random(i)
			missionIds[i], missionIds[j] = missionIds[j], missionIds[i]
		end

		-- Select a subset of missions (e.g., first 4)
		local selectedMissions = {}
		for i = 1, math.min(3, #missionIds) do
			local missionId = missionIds[i]
			local missionInfo = missionConfig[missionId]
			selectedMissions[missionId] = {
				name = missionInfo.name,
				missionId = missionId,
				type = "DailyMission",
				currentGoalIndex = 1, -- Start with the first goal
				progress = 0,
				completedGoals = {}, -- Track completed goals
				claimedRewards = {}, -- Track claimed rewards per goal
			}
		end

		profile.Data.missions = selectedMissions
		profile.Data.missionDate = currentDate
		playerDataService.setProfile(player, profile)
	end

	playerMissions[userId] = profile.Data.missions
end

-- Update mission progress
function missionService.updateMissionProgress(player, requirement, progressType, amount)
	local userId = player.UserId
	local missions = playerMissions[userId]
	if not missions then
		return
	end

	for missionId, missionData in missions do
		local missionConfigData = missionConfig[missionId]
		if
			missionConfigData.requirement == requirement
			and missionConfigData.type == progressType
			and missionData.currentGoalIndex <= #missionConfigData.goals
		then
			local currentGoal = missionConfigData.goals[missionData.currentGoalIndex]
			missionData.progress += amount

			if missionData.progress >= currentGoal then
				missionService.claimMissionReward(player, missionId, missionData.currentGoalIndex)

				missionData.completedGoals[missionData.currentGoalIndex] = true
				missionData.currentGoalIndex += 1
				missionData.progress = 0
			end

			-- Notify the client about the mission update
			zap.missionUpdated.Fire(player)
		end
	end
end

-- Grant rewards based on the mission's reward configuration
function missionService.grantRewards(player, missionId, goalIndex)
	local profile = playerDataService.getProfile(player)
	local missionInfo = missionConfig[missionId]

	if not missionInfo or not missionInfo.rewards then
		return
	end

	local rewardType = missionInfo.reward
	local rewardAmount = missionInfo.rewards[goalIndex]

	if rewardType and rewardAmount then
		if rewardType == "coins" then
			moneyService.addMoney(player, rewardAmount)
		elseif rewardType == "xp" then
			levelService.addExperience(player, rewardAmount)
			-- Add other reward types as needed
		end
		playerDataService.setProfile(player, profile)
	end
end

-- Claim reward for a specific mission goal
function missionService.claimMissionReward(player, missionId, goalIndex)
	local userId = player.UserId
	local missions = playerMissions[userId]
	if not missions then
		return false
	end

	local missionData = missions[missionId]
	if not missionData then
		return false
	end

	if missionData.completedGoals[goalIndex] and not missionData.claimedRewards[goalIndex] then
		missionData.claimedRewards[goalIndex] = true
		missionService.grantRewards(player, missionId, goalIndex)
		zap.missionRewardClaimed.Fire(player, { taskId = missionId, goalId = goalIndex })
		return true
	end

	return false
end

-- Start the MissionService
function missionService.start()
	-- RemoteFunction handlers
	zap.getPlayerMissions.SetCallback(function(player)
		local userId = player.UserId
		return playerMissions[userId] or {}
	end)

	zap.claimMissionRewards.SetCallback(function(player, missionId, goalIndex)
		return missionService.claimMissionReward(player, missionId, goalIndex)
	end)

	playerDataService.playerDataLoaded:Connect(function(player)
		missionService.initializePlayer(player)
	end)

	-- Handling kill missions here
	weaponConfig.signals.kill:Connect(function(shooter, hitZombie)
		local zombieCfg = zombieStatConfig[hitZombie.Name]
		if not zombieCfg then
			return
		end

		missionService.updateMissionProgress(
			shooter,
			"kill",
			zombieCfg.type == "elite" and "elites" or "zombies",
			1
		)
	end)

	-- Handling collect money missions here
	moneyService.addedMoney:Connect(function(player, amt)
		missionService.updateMissionProgress(player, "collect", "coins", amt)
	end)

	Players.PlayerRemoving:Connect(function(player)
		local profile = playerDataService.getProfile(player)
		profile.Data.missions = playerMissions[player.UserId]
		playerDataService.setProfile(player, profile)
	end)
end

return missionService
