local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local playerDataService = require(ServerStorage.server.services.playerDataService)
local shopConfig = require(ReplicatedStorage.shared.configurations.shopConfig)
local weaponService = require(ServerStorage.server.services.weaponService)
local zap = require(ServerStorage.zap)

local weaponsFolder = ServerStorage.Weapons

local inventoryService = {}

local weaponLookup = {}

local function getWeaponClass(weaponName)
	return weaponLookup[weaponName]
end

function inventoryService.checkIfIsWeaponType(tool: Tool, type)
	local success, ws = pcall(function()
		return weaponService.getWeaponSettings(tool.Name)
	end)
	if success and ws then
		if ws.itemType == type then
			return true
		end
	end
	return false
end

function inventoryService.getWeaponOfTypeFromPlayer(player: Player, weaponType)
	local character = player.Character or player.CharacterAdded:Wait()
	local equippedTool = character:FindFirstChildWhichIsA("Tool")
	if equippedTool then
		if inventoryService.checkIfIsWeaponType(equippedTool, weaponType) then
			return equippedTool
		end
	end

	local backpack = player:FindFirstChildWhichIsA("Backpack") or player:WaitForChild("Backpack", 5)
	if not backpack then
		return
	end

	for _, tool in backpack:GetChildren() do
		if inventoryService.checkIfIsWeaponType(tool, weaponType) then
			return tool
		end
	end
	return
end

function inventoryService.equipWeapon(player, weaponName)
	local weapon = weaponsFolder:FindFirstChild(weaponName)
	if not weapon then
		return
	end
	local profile = playerDataService.getProfile(player)
	if not table.find(profile.Data.ownedWeapons, weaponName) then
		return
	end

	local ws = weaponService.getWeaponSettings(weaponName)
	local current = inventoryService.getWeaponOfTypeFromPlayer(player, ws.itemType)
	if current then
		current:Destroy()
	end
	profile.Data[ws.itemType] = weaponName
	profile.Data.weaponClass = getWeaponClass(weaponName)

	weapon:Clone().Parent = player.Backpack

	playerDataService.setProfile(player, profile)
end

function inventoryService.start()
	for weaponClass, weapons in shopConfig do
		for weaponName, _ in weapons do
			weaponLookup[weaponName] = weaponClass
		end
	end

	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function()
			local profile = playerDataService.getProfile(player)
			if not profile then
				return
			end
			inventoryService.equipWeapon(player, profile.Data.gun)
			inventoryService.equipWeapon(player, profile.Data.melee)
			inventoryService.equipWeapon(player, profile.Data.equipment)
		end)
	end)
	zap.equipWeapon.SetCallback(function(player, weaponName)
		inventoryService.equipWeapon(player, weaponName)
	end)
end

return inventoryService
