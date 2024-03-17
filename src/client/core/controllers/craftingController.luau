local ReplicatedStorage = game:GetService("ReplicatedStorage")

local craftingRecipes = require(ReplicatedStorage.shared.configurations.craftingRecipes)
local zap = require(ReplicatedStorage.zap)

local crafting = {}

function crafting.start()
	-- TODO: Make UI
end

function crafting.craft(itemName: string)
	zap.Craft.Fire(itemName)
end

return crafting
