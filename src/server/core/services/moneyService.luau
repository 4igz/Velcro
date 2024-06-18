local ServerStorage = game:GetService("ServerStorage")
local playerDataService = require(ServerStorage.server.services.playerDataService)
local moneyService = {}

function moneyService.addMoney(player: Player, amt: number)
	local profile = playerDataService.getProfile(player)

	profile.Data.Money += amt

	playerDataService.setProfile(player, profile)
end

return moneyService
