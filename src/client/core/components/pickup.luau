local MINIMUM_DISTANCE_TO_PICKUP = 5

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local sharedPackages = ReplicatedStorage.sharedPackages
local shared = ReplicatedStorage.shared

local Component = require(sharedPackages.Component)
local Signal = require(sharedPackages.Signal)
local Trove = require(sharedPackages.Trove)
local pickupTypes = require(ReplicatedStorage.shared.configurations.pickupTypes)
local sharedInfo = require(shared.sharedInfo)
local zap = require(ReplicatedStorage.zap)

local getDataRF: RemoteFunction = ReplicatedStorage:WaitForChild("GetData")

local Pickup = Component.new({
	tag = "Pickup",
})

function Pickup:construct()
	self._trove = Trove.new()

	local pickupSettings = pickupTypes[self.instance.Name]
	self.requiredLevel = pickupSettings.requiredLevel or 1
	self.name = self.instance.Name

	self.part = if self.instance:IsA("BasePart")
		then self.instance
		else self.instance:FindFirstChildWhichIsA("BasePart")

	assert(self.part:IsA("BasePart"), `No part found for pickup {self.instance}`)

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Pickup"
	prompt.ObjectText = self.name
	prompt.Parent = self.part
	prompt.MaxActivationDistance = pickupSettings.pickupDistance or MINIMUM_DISTANCE_TO_PICKUP
	self.prompt = prompt
end

function Pickup:start()
	self._trove:Add(self.instance)

	self._trove:Add(self.prompt.Triggered:Connect(function(player)
		local playerData = getDataRF:InvokeServer()

		if not playerData then
			return
		end

		if self.requiredLevel > playerData.levels.Gathering.level then
			return
		end

		zap.Pickup.Fire({ itemId = self.instance:GetAttribute("ItemId") })
	end))
end

function Pickup:stop()
	self._trove:Destroy()
end

return Pickup
