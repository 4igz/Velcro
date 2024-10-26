-- A relatively basic player data service that is fully functional.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local ProfileService = require(ServerStorage.serverPackages.ProfileService)
local Sift = require(ReplicatedStorage.sharedPackages.Sift)
local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local skillConfig = require(ReplicatedStorage.shared.configurations.skillConfig)
local zap = require(ServerStorage.zap)

local Profiles = {} -- [player] = profile

local playerDataService = {}

type PlayerProfile = {
	Money: number,
	Experience: number,
	Level: number,
	Kills: number,

	gun: string,
	melee: string,
	equipment: string,

	ownedWeapons: { string },
}

local function generateSkillTree(skillConfig)
	local skillTree = {}
	for weaponType, skills in skillConfig do
		skillTree[weaponType] = {}
		for _, skill in skills do
			table.insert(skillTree[weaponType], { unlocked = false, level = 0 })
		end
	end
	return skillTree
end

-- ProfileTemplate table is what empty profiles will default to.
playerDataService.ProfileTemplate = {
	-- Leaderstats
	Money = 1000,
	Experience = 0,
	Level = 1,
	Kills = 0,
	Rebirth = 0,

	-- State
	gun = "Starter Pistol",
	melee = "",
	equipment = "",

	weaponClass = "pistol",

	ownedWeapons = {
		"Starter Pistol",
	},

	rampageEssence = 0,
	skillPoints = 0,

	skillTree = generateSkillTree(skillConfig),
}

local ProfileStore = ProfileService.GetProfileStore("V0.1.0", playerDataService.ProfileTemplate)
playerDataService.playerDataLoaded = Signal.new()
playerDataService.playerDataChanged = Signal.new()

-- Sync player data to attributes
local function syncDataToAttributes(player, data)
	for key, value in data do
		if player:GetAttribute(key) ~= value and type(value) ~= "table" then
			player:SetAttribute(key, value)
		end
	end
end

-- Sync attributes back to the player data
local function syncAttributesToData(player)
	local profile = Profiles[player]
	if not profile then
		return
	end

	local updatedData = {}
	for key, _ in pairs(playerDataService.ProfileTemplate) do
		local attributeValue = player:GetAttribute(key)
		if attributeValue ~= nil then
			updatedData[key] = attributeValue
		end
	end

	playerDataService.updateProfile(player, updatedData)
end

local function playerAdded(player: Player)
	local profile = ProfileStore:LoadProfileAsync(`Player_{player.UserId}`)
	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
		profile:ListenToRelease(function()
			Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick()
		end)
		if player:IsDescendantOf(Players) == true then
			Profiles[player] = profile
			playerDataService.playerDataLoaded:Fire(player)

			-- Sync profile data to player attributes
			syncDataToAttributes(player, profile.Data)

			-- Listen for attribute changes and sync them back to profile data
			for name, v in player:GetAttributes() do
				player:GetAttributeChangedSignal(name):Connect(function()
					syncAttributesToData(player)
				end)
			end
		else
			-- The profile couldn't be loaded possibly due to other
			--   Roblox servers trying to load this profile at the same time:
			profile:Release()
			player:Kick()
		end
	end
end

function playerDataService.start()
	-- Create profile for players who could have joined before this script started.
	for _, player in Players:GetPlayers() do
		task.spawn(playerAdded, player)
	end

	Players.PlayerAdded:Connect(playerAdded)

	Players.PlayerRemoving:Connect(function(player)
		local profile = Profiles[player]
		if profile ~= nil then
			profile:Release()
		end
	end)

	zap.getSkillTree.SetCallback(function(player)
		local profile = Profiles[player]
		if profile then
			return profile.Data.skillTree
		end
		return
	end)

	zap.getSkillPoints.SetCallback(function(player)
		local profile = Profiles[player]
		if profile then
			return {
				rampageEssence = profile.Data.rampageEssence,
				skillPoints = profile.Data.skillPoints,
			}
		end
		return
	end)

	playerDataService.playerDataChanged:Connect(function(changedPlayer, newProfile)
		if newProfile and newProfile.Data then
			syncDataToAttributes(changedPlayer, newProfile.Data)
		end
	end)

	zap.attributeChangedEvent.SetCallback(function(player, data)
		if RunService:IsStudio() then
			player:SetAttribute(data.name, data.value.value)
			syncAttributesToData(player)
		end
	end)
end

-- Preferably used inside of PlayerAdded events
function playerDataService.waitForProfile(player: Player): { Data: PlayerProfile }?
	while player:IsDescendantOf(Players) do
		local profile = Profiles[player]
		if profile then
			return profile
		end
		task.wait(0.1)
	end
	return
end

function playerDataService.updateProfile(player: Player, newData: { [any]: any })
	local playerProfile = playerDataService.getProfile(player)
	local mergedData = Sift.Dictionary.merge(playerProfile.Data, newData)
	playerProfile.Data = mergedData
	playerDataService.setProfile(player, mergedData)
end

function playerDataService.getProfile(player: Player): { Data: PlayerProfile }?
	if player:IsDescendantOf(Players) and not Profiles[player] then
		return playerDataService.waitForProfile(player)
	end
	return Profiles[player]
end

function playerDataService.setProfile(player: Player, newProfile: PlayerProfile)
	if not (player:IsDescendantOf(Players) and Profiles[player]) then
		return
	end
	playerDataService.playerDataChanged:Fire(player, newProfile)
end

return playerDataService
