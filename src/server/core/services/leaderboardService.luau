local CollectionService = game:GetService("CollectionService")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local numberUtil = require(ReplicatedStorage.shared.utilities.numberUtil)
local playerDataService = require(ServerStorage.server.services.playerDataService)
-- local playerUtil = require(ReplicatedStorage.shared.utilities.playerUtil)
local zap = require(ServerStorage.zap)
local leaderboardService = {}

local LB_DISPLAY_NUM = 100

local statToList = {}

function leaderboardService.start()
	for _, leaderboard in CollectionService:GetTagged("Leaderboard") do
		task.spawn(function()
			local trackedStat = leaderboard:GetAttribute("TrackingStat")
			local dataStore = DataStoreService:GetOrderedDataStore(trackedStat)

			local function updateLeaderboard()
				for _, player in Players:GetPlayers() do
					if player.UserId < 1 then
						continue
					end

					local profile = playerDataService.getProfile(player)

					if not profile or not profile.Data then
						continue
					end

					local success, error = pcall(function()
						dataStore:UpdateAsync(player.UserId, function()
							if not profile.Data[trackedStat] then
								return error(`{trackedStat} does not exist in our profiles!`)
							end
							return math.floor(profile.Data[trackedStat])
						end)
					end)

					if not success then
						warn(error)
					end
				end

				local minValue = 1
				local maxValue = 10e69
				local pages = dataStore:GetSortedAsync(false, LB_DISPLAY_NUM, minValue, maxValue)
				local top = pages:GetCurrentPage()
				local list = {}
				for _, entry in top do
					local userId = entry.key
					local stat = entry.value
					local username = "[Failed To Load]"
					local success, err = pcall(function()
						username = Players:GetNameFromUserIdAsync(userId)
					end)
					if not success then
						warn("Error getting name for " .. userId .. ". Error: " .. err)
					end
					-- local image = playerUtil.avatarImage(
					-- 	userId,
					-- 	Enum.ThumbnailSize.Size150x150,
					-- 	Enum.ThumbnailType.HeadShot
					-- )
					table.insert(list, { playerName = username, score = stat })
				end

				statToList[trackedStat] = list

				zap.updateLbData.FireAll({ trackingStat = trackedStat, lbData = list })
			end

			updateLeaderboard()

			task.spawn(function()
				Players.PlayerAdded:Wait()
				while true do
					updateLeaderboard()
					task.wait(360)
				end
			end)
		end)
	end

	zap.getLbData.SetCallback(function(player, trackedStat)
		return statToList[trackedStat]
	end)
end

return leaderboardService
