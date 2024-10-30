local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local playerDataService = require(ServerStorage.server.services.playerDataService)
local moneyService = {}

moneyService.addedMoney = Signal.new()

function moneyService.addMoney(player: Player, amt: number)
	local profile = playerDataService.getProfile(player)

	profile.Data.Money += amt
	moneyService.addedMoney:Fire(player, amt)

	playerDataService.setProfile(player, profile)
end

return moneyService
