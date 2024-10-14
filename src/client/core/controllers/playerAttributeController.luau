local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local zap = require(ReplicatedStorage.zap)

local playerAttributeController = {}

local function editAttribute(
	player,
	attributeName: string,
	attributeValue: number | string | boolean
)
	-- Notify the server about the attribute change
	zap.attributeChangedEvent.Fire({
		name = attributeName,
		value = { type = string.sub(type(attributeValue), 1, 3), value = attributeValue },
	})
end

local function setupAttributeEditor(player)
	-- Connect to all attribute changes
	player.AttributeChanged:Connect(function(attributeName)
		editAttribute(player, attributeName, player:GetAttribute(attributeName))
	end)
end

function playerAttributeController.start()
	-- This is a testing module who's logic should only apply in studio!!
	if not RunService:IsStudio() then
		return
	end

	setupAttributeEditor(Players.LocalPlayer)
end

return playerAttributeController
