local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local inventoryService = require(script.Parent.inventoryService)
local levelService = require(script.Parent.levelService)
local pickupTypes = require(ReplicatedStorage.shared.configurations.pickupTypes)
local playerDataService = require(script.Parent.playerDataService)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local zap = require(ServerStorage.zap)

local pickupFolder = ReplicatedStorage.assets.pickups

local pickupService = {}

local pickups: { [Player]: { [string]: any } } = {}

local PICKUP_CREATION_COOLDOWN = 5

function pickupService.start()
	-- When player tries to pick something up
	zap.Pickup.SetCallback(function(player, data)
		local pickup = pickups[player][data.itemId]
		if pickup then
			pickupService.pickup(player, pickup)
		end
	end)

	local now = time()
	RunService.Heartbeat:Connect(function(dt)
		if time() < now + PICKUP_CREATION_COOLDOWN then
			return
		end
		now = time()

		for _, player in Players:GetPlayers() do
			local profile = playerDataService.getProfile(player)
			for _, pickupType in pickupService.getPickupsForIsland(profile.Data.currentIsland) do
				local should, pickups = pickupService.shouldCreatePickup(player, pickupType)
				if should then
					for i = 1, pickups do
						pickupService.createPickupFor(player, pickupType)
					end
				end
			end
		end
	end)
end

function pickupService.createPickupFor(player, pickupType)
	local pickupInstance = pickupFolder:FindFirstChild(pickupType)
	local pickupSettings = pickupTypes[pickupType]
	assert(pickupInstance and pickupSettings, `Pickup {pickupType} was not found correctly!`)

	local island = workspace:FindFirstChild(pickupSettings.island)
	assert(island, `Island {pickupSettings.island} was not found for pickupType {pickupType}`)
	local islandBaseplate = island.IslandBaseplate

	local baseplateArea = ((3 * math.sqrt(3)) / 2) * ((islandBaseplate.Size.X / 2) * 0.25)
	-- TODO: Recalculate position if it lands inside something
	local position = islandBaseplate.Position
		+ Vector3.new(
			math.random(-baseplateArea, baseplateArea),
			2,
			math.random(-baseplateArea, baseplateArea)
		)
	local itemId = string.lower(string.sub(HttpService:GenerateGUID(false), 1, 8))

	local pickupInfo = { pickupType = pickupType, position = position, itemId = itemId }

	pickups[player][itemId] = pickupInfo

	zap.RevealPickup.Fire(player, pickupInfo)
end

function pickupService.pickup(player, pickupInfo)
	local character = player.Character
	local primaryPart = character and character.PrimaryPart
	if not primaryPart then
		return
	end

	local settings = pickupTypes[pickupInfo.pickupType]
	local pickupPosition = pickupInfo.position
	local distanceToPickup = (primaryPart.Position - pickupPosition).Magnitude

	if
		distanceToPickup < (settings.pickupDistance * 2)
		and levelService.getLevelType(player, "Gathering").level >= settings.requiredLevel
	then
		local profile = playerDataService.getProfile(player)
		profile.Data.inventory[pickupInfo.pickupType] += 1
		playerDataService.setProfile(player, profile)

		levelService.addExperience(player, "Gathering", settings.gatheringExperience)
		inventoryService.updateBackpack(player)
		zap.DestroyPickup.Fire(player, { itemId = pickupInfo.itemId })
		pickups[player][pickupInfo.itemId] = nil
	end
end

function pickupService.getPickupsForIsland(islandName: string)
	local islandPickups = {}
	for name, settings in pickupTypes do
		if settings.island == islandName then
			islandPickups[name] = name
		end
	end
	return islandPickups
end

function pickupService.shouldCreatePickup(player, pickupType)
	local playerPickups = pickups[player]
	if not playerPickups then
		pickups[player] = {}
		playerPickups = pickups[player]
	end
	local numPickups = 0
	for _, info in playerPickups do
		if info.pickupType ~= pickupType then
			continue
		end
		numPickups += 1
	end
	local pickupSettings = pickupTypes[pickupType]
	if numPickups >= pickupSettings.maxPickupsOnIsland then
		return false
	end

	return true, pickupSettings.maxPickupsOnIsland - numPickups
end

return pickupService
