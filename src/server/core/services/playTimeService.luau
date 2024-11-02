local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local playerDataService = require(ServerStorage.server.services.playerDataService)
local zap = require(ServerStorage.zap)
local playTimeService = {}

local REWARD_INTERVALS = {
	[300] = { coins = 500 },
	[600] = { coins = 1000 },
	[900] = { xp = 1000 },
	[1500] = { coins = 5000 },
	[1800] = { xp = 2000 },
	[2700] = { coins = 10000 },
	[3600] = { coins = 10000, xp = 5000 },
}

local lastUpdateTime = {}

function playTimeService.start()
	task.spawn(function()
		while true do
			for _, player in Players:GetPlayers() do
				-- Initialize player tracking if not present
				lastUpdateTime[player] = (lastUpdateTime[player] or 0) + 1

				if lastUpdateTime[player] >= 1 then
					local profile = playerDataService.getProfile(player)

					-- Check for rewards based on the player's playtime
					for interval, reward in REWARD_INTERVALS do
						if profile.Data.lbStats.PlayTime == interval then
							if reward.coins then
								profile.Data.Money += reward.coins
								zap.updateFeeds.Fire(player, {
									type = "money",
									amtGain = reward.coins,
									reason = "Playtime reward",
								})
							end

							if reward.xp then
								profile.Data.XP = (profile.Data.XP or 0) + reward.xp
								zap.updateFeeds.Fire(player, {
									type = "xp",
									amtGain = reward.xp,
									reason = "Playtime reward",
								})
							end
						end
					end

					-- Reset the time tracker and update player data
					lastUpdateTime[player] = 0
					--stylua: ignore
					profile.Data.lbStats.PlayTime = (profile.Data.lbStats.PlayTime or 0) + 1
					playerDataService.setProfile(player, profile)
				end
			end
			task.wait(1)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		lastUpdateTime[player] = nil
	end)
end

return playTimeService
