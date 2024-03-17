local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local generatorConfig = require(ReplicatedStorage.shared.configurations.generatorConfig)
local numberUtil = require(ReplicatedStorage.shared.utilities.numberUtil)
local playerDataService = require(script.Parent.playerDataService)
local zap = require(ServerStorage.zap)

local GENERATOR_COOLDOWN = 1
local GENERATOR_COST_INCREASE = 0.15
local GET_ENERGY_COOLDOWN = 0.1

local clickCooldowns = {}
local generatorCooldowns = {}
local energyService = {}

function energyService.start()
	zap.GetEnergy.SetCallback(function(player)
		local now = time()
		if now < (clickCooldowns[player] or 0) + GET_ENERGY_COOLDOWN then
			return
		end
		clickCooldowns[player] = now

		local playerProfile = playerDataService.getProfile(player)
		playerProfile.Data.energy += playerProfile.Data.upgrades.energyPerClick
		playerDataService.setProfile(player, playerProfile)
	end)

	zap.BuyGenerator.SetCallback(function(player, data)
		local name = data.generatorName
		local amt = data.amt or 1
		local genInfo = generatorConfig[name]
		assert(genInfo, `No config found for generator {name}`)

		local playerProfile = playerDataService.getProfile(player)

		local scaledEnergy = genInfo.cost
			* ((1 + GENERATOR_COST_INCREASE) ^ playerProfile.Data.generators[name] + data.amt)

		if playerProfile.Data.energy >= scaledEnergy then
			playerProfile.Data.generators[name] += amt
			playerProfile.Data.energy -= scaledEnergy
			playerDataService.setProfile(player, playerProfile)
		end
	end)

	-- Make generators generate energy for players
	RunService.Heartbeat:Connect(function(_dt)
		for _, player in Players:GetPlayers() do
			local now = time()
			if now < (generatorCooldowns[player] or 0) + GENERATOR_COOLDOWN then
				return
			end
			generatorCooldowns[player] = now

			-- Generate energy for each player based on their generators
			local playerProfile = playerDataService.getProfile(player)

			for name, amt in playerProfile.Data.generators do
				if amt == 0 then
					continue
				end
				local info = generatorConfig[name]

				local generatedEnergy = info.gen * amt
				playerProfile.Data.energy += generatedEnergy
			end

			playerDataService.setProfile(player, playerProfile)
		end
	end)

	Players.PlayerAdded:Connect(function(player)
		local playerProfile = playerDataService.getProfile(player)
		zap.UpdateEnergy.Fire(
			player,
			{ energy = numberUtil.simplifyNumber(playerProfile.Data.energy) }
		)
	end)
end

return energyService
