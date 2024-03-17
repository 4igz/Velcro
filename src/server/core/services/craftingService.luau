local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local craftingRecipes = require(ReplicatedStorage.shared.configurations.craftingRecipes)
local inventoryService = require(script.Parent.inventoryService)
local playerDataService = require(script.Parent.playerDataService)
local zap = require(ServerStorage.zap)

local craftingService = {}

function craftingService.start()
	zap.Craft.SetCallback(function(player, data)
		local recipe = craftingRecipes[data.itemName]
		assert(recipe, `Recipe not found for {data.itemName}`)

		local profile = playerDataService.getProfile(player)
		local inventory = profile.Data.inventory

		local allCheck = true
		for name, amt in recipe do
			if inventory[name] < amt then
				allCheck = false
				break
			end
		end

		if allCheck then
			for name, _ in inventory do
				inventory[name] -= recipe[name]
			end
			playerDataService.setProfile(player, profile)
			inventoryService.updateBackpack(player)
		end
	end)
end

return craftingService
