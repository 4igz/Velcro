local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sharedPackages = ReplicatedStorage.sharedPackages
local shared = ReplicatedStorage.shared

local Promise = require(sharedPackages.Promise)
local sharedInfo = require(shared.sharedInfo)

local monetizationUtil = {}

function monetizationUtil.userOwnsGamepass(userId: number, gamepassId: number)
	return Promise.new(function(resolve)
		local gamepassName
		for name, id in sharedInfo.Gamepasses do
			if id == gamepassId then
				gamepassName = name
			end
		end
		if table.find(sharedInfo.GamepassBypass[gamepassName], userId) then
			resolve(true)
			return
		end
		local wasSuccessful, owns =
			pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, userId, gamepassId)

		resolve(if wasSuccessful then owns else false)
	end)
end

return table.freeze(monetizationUtil)
