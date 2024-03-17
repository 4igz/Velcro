local ReplicatedStorage = game:GetService("ReplicatedStorage")

local pickupComponent = require(ReplicatedStorage.client.components.pickup)
local pickupTypes = require(ReplicatedStorage.shared.configurations.pickupTypes)
local zap = require(ReplicatedStorage.zap)

local pickupFolder = ReplicatedStorage.assets.pickups

local pickupController = {}

local pickups = {}

function pickupController.start()
	zap.RevealPickup.SetCallback(function(data)
		local pickup = pickupFolder:FindFirstChild(data.pickupType)
		local pickupInstance = pickup:Clone()

		pickupInstance.Position = data.position
		pickupInstance:SetAttribute("ItemId", data.itemId)
		pickupInstance.Parent = workspace:FindFirstChild(pickupTypes[data.pickupType].island)

		table.insert(pickups, pickupInstance)
	end)

	zap.DestroyPickup.SetCallback(function(data)
		for _, instance in pickups do
			if instance:GetAttribute("ItemId") == data.itemId then
				local component = pickupComponent:fromInstance(instance)
				component:stop()
			end
		end
	end)
end

return pickupController
