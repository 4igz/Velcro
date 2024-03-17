local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local playerDataService = require(ServerStorage.server.services.playerDataService)

local tools = ServerStorage.assets.tools

local inventoryService = {}

function inventoryService.start() end

function inventoryService.updateBackpack(player: Player)
	-- Backpack can be nil when player dies
	local backpack = player:WaitForChild("Backpack")
	local character = player.Character or player.CharacterAdded:Wait()
	local profile = playerDataService.getProfile(player)

	for name, itemNum in profile.Data.inventory do
		if itemNum > 0 then
			local tool = tools:FindFirstChild(name)
			local existingTool = character:FindFirstChild(name) or backpack:FindFirstChild(name)

			if not tool or (existingTool and existingTool:IsA("Tool")) then
				continue
			end

			if tool then
				tool:Clone().Parent = backpack
			end
		end
	end
end

return inventoryService
